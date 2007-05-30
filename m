Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbXE3DAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbXE3DAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 23:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXE3DAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 23:00:24 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:55720 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbXE3DAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 23:00:24 -0400
X-Greylist: delayed 3901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 23:00:24 EDT
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Wed, 30 May 2007 01:46:45 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f3il25$pcp$1@taverner.cs.berkeley.edu>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <20070529144518.GD5840@ucw.cz> <Pine.LNX.4.64.0705291622430.31474@asgard.lang.hm> <20070529233041.GC24200@elf.ucw.cz>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1180489605 26009 128.32.168.222 (30 May 2007 01:46:45 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Wed, 30 May 2007 01:46:45 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> no, this won't help you much against local users, [...]

Pavel Machek  wrote:
>Hmm, I guess I'd love "it is useless on multiuser boxes" to become
>standard part of AA advertising.

That's not quite what david@ said.  As I understand it, AppArmor is not
focused on preventing attacks by local users against other local users;
that's not the main problem it is trying to solve.  Rather, it's primary
purpose is to deal with attacks by remote bad guys against your network
servers.  That is a laudable goal.  Anything that helps reduce the impact
of remote exploits is bound to be useful, even if doesn't do a darn
thing to stop local users from attacking each other.

This means that AppArmor could still be useful on multiuser boxes,
even if that utility is limited to defending (some) network daemons
against remote attack (or, more precisely, reducing the damage done by
a successful remote attack against a network daemon).
