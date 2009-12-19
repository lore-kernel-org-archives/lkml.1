Return-Path: <linux-kernel-owner+w=401wt.eu-S1751867AbZLSMCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbZLSMCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 07:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZLSMCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 07:02:10 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:38540 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbZLSMCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 07:02:09 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH] Security: Add prctl(PR_{GET,SET}_NETWORK) interface.
Date: Sat, 19 Dec 2009 12:02:05 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hgifbt$mme$1@taverner.cs.berkeley.edu>
References: <20091218030056.GC3047@heat> <20091218094955.32938765@nehalam>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1261224125 23246 128.32.153.193 (19 Dec 2009 12:02:05 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sat, 19 Dec 2009 12:02:05 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger  wrote:
>Michael Stone <michael@laptop.org> wrote:
>>    5. Linux today has pretty good support for controlling the creation of
>>       channels involving the filesystem and involving shared daemons. It has
>>       mediocre support for access control involving sysv-ipc
>mechanisms. It has
>>       terrible support for access control involving non-local principals like
>>       "the collection of people and programs receiving packets sent to
>>       destination 18.0.0.1:80 from source 192.168.0.3:34661".
>
>The policy control for this is done today on linux via the firewalling
>infrastructure.

I don't know of any reasonable way to introduce firewall rules
that apply only to a specific process; nor do I know of any way
for a user-level (non-root) process to specify and apply such
rules.  So it doesn't sound to me like the firewalling infrastructure
meets the requirements for which this patch was introduced.  Or did
I miss something?
