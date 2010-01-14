Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077Ab0ANOae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab0ANOae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 09:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358Ab0ANOad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 09:30:33 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:43548 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab0ANOad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 09:30:33 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Date: Thu, 14 Jan 2010 14:30:30 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hin9q6$hvk$1@taverner.cs.berkeley.edu>
References: <alpine.LRH.2.00.1001110811350.25601@tundra.namei.org> <20100110215848.GA26609@elf.ucw.cz> <20100112075927.GA24256@atrey.karlin.mff.cuni.cz> <20100114092250.GA11500@atrey.karlin.mff.cuni.cz>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1263479430 18420 128.32.153.193 (14 Jan 2010 14:30:30 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 14 Jan 2010 14:30:30 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek  wrote:
>> On Tue, 12 Jan 2010 08:59:27 +0100, Pavel Machek said:
>> > Well, maybe, but mailer system where first user starts is as a daemon
>> > makes sense...
>> 
>> Does it?  How do you get port 25 open for listening if the first user isn't
>> root?  Most *actual* schemes to "launch at first use" that require privs for
>> something have used inetd or similar - that program exists for a
>> *reason*.
>
>Remember sendmail is setuid root... so it already has the permissions.

sendmail hasn't been setuid root on my system for (what feels like)
a long time; rather, it is setgid to a special group.

$ ls -l /usr/sbin/sendmail.sendmail 
-rwxr-sr-x 1 root smmsp 841528 2008-03-29 05:27 /usr/sbin/sendmail.sendmail*
