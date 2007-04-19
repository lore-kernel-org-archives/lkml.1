Return-Path: <linux-kernel-owner+w=401wt.eu-S1766864AbXDSQmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766864AbXDSQmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766867AbXDSQmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:42:42 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:43930 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766864AbXDSQml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:42:41 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: AppArmor FAQ
Date: Thu, 19 Apr 2007 16:35:28 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f085og$3hg$1@taverner.cs.berkeley.edu>
References: <20070417181016.GA10903@one.firstfloor.org> <Line.LNX.4.64.0704180935100.25495@d.namei> <4626746A.9010701@novell.com> <Line.LNX.4.64.0704181620130.27545@d.namei>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1177000528 3632 128.32.168.222 (19 Apr 2007 16:35:28 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 19 Apr 2007 16:35:28 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris  wrote:
>On Wed, 18 Apr 2007, Crispin Cowan wrote:
>> How is it that you think a buffer overflow in httpd could allow an
>> attacker to break out of an AppArmor profile?
>
>Because you can change the behavior of the application and then bypass 
>policy entirely by utilizing any mechanism other than direct filesystem 
>access: IPC, shared memory, Unix domain sockets, local IP networking, 
>remote networking etc.

Any halfway decent jail will let you control access to all of those
things, thereby preventing an 0wned httpd from breaking out of the jail.
(For instance, Janus did.  So does Systrace.)

Are you saying AppArmor does not allow that kind of control?  Specifics
would be useful.

>Also worth noting here is that you have to consider any limited 
>environment as enforcing security policy, and thus its configuration 
>becomes an additional component of security policy.

I don't understand what you are saying.  Yes, the AppArmor policy
file is part of policy.  Is that what you mean?
