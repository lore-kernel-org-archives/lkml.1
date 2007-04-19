Return-Path: <linux-kernel-owner+w=401wt.eu-S965271AbXDSUyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271AbXDSUyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965301AbXDSUyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:54:18 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:59514 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965271AbXDSUyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:54:17 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: AppArmor FAQ
Date: Thu, 19 Apr 2007 20:47:01 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f08kg5$c88$1@taverner.cs.berkeley.edu>
References: <20070417181016.GA10903@one.firstfloor.org> <Line.LNX.4.64.0704181620130.27545@d.namei> <f085og$3hg$1@taverner.cs.berkeley.edu> <1177004348.27654.139.camel@moss-spartans.epoch.ncsc.mil>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1177015621 12552 128.32.168.222 (19 Apr 2007 20:47:01 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 19 Apr 2007 20:47:01 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Crispin Cowan wrote:
> How is it that you think a buffer overflow in httpd could allow an
> attacker to break out of an AppArmor profile?

James Morris  wrote:
> [...] you can change the behavior of the application and then bypass 
> policy entirely by utilizing any mechanism other than direct filesystem 
> access: IPC, shared memory, Unix domain sockets, local IP networking, 
> remote networking etc.
[...]
> Just look at their code and their own description of AppArmor.

My gosh, you're right.  What the heck?  With all due respect to the
developers of AppArmor, I can't help thinking that that's pretty lame.
I think this raises substantial questions about the value of AppArmor.
What is the point of having a jail if it leaves gaping holes that
malicious code could use to escape?

And why isn't this documented clearly, with the implications fully
explained?

I would like to hear the AppArmor developers defend this design decision.
When we developed Janus, over 10 years ago, we defended against these
attack avenues and protected everything -- not just the filesystem.
Systrace does the same, as does Plash.  So does Consh, and MapBox, and
Ostia, to name a few other examples from the research world.  This is
standard stuff that is well-documented in the literature, and it seems to
me it is necessary before you can claim to have a useful jail.  What am
I missing?


P.S. I think the criticisms that "AppArmor is pathname-based" or
"AppArmor doesn't do everything SELinux does" or "AppArmor doesn't do
information flow control" are weak.  But the criticism that "AppArmor
leaves security holes that can be used to escape the jail" seems like
a serious criticism to me.  Perhaps a change of focus is in order.
