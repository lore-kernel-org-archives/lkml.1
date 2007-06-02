Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbXFBEkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbXFBEkT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 00:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXFBEkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 00:40:08 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:49363 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXFBEkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 00:40:07 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Sat, 2 Jun 2007 04:30:30 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f3qrp6$ftn$1@taverner.cs.berkeley.edu>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <f3il25$pcp$1@taverner.cs.berkeley.edu> <20070524144726.GB3920@ucw.cz> <12508.1180719875@turing-police.cc.vt.edu>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1180758630 16311 128.32.168.222 (2 Jun 2007 04:30:30 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sat, 2 Jun 2007 04:30:30 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:
>Experience over on the Windows side of the fence indicates that "remote bad
>guys get some local user first" is a *MAJOR* part of the current real-world
>threat model - the vast majority of successful attacks on end-user boxes these
>days start off with either "Get user to (click on link|open attachment)" or
>"Subvert the path to a website (either by hacking the real site or hijacking
>the DNS) and deliver a drive-by fruiting when the user visits the page".

AppArmor isn't trying to defend everyday users from getting phished or
social engineered; it is trying to protect servers from getting rooted
because of security holes in their network daemons.  I find that a
laudable goal.  Sure, it doesn't solve every security problem in the
world, but so what?  A tool that could solve that one security problem
would still be a useful thing, even if it did nothing else.

I don't find the Windows stuff too relevant here.  As I understand it,
AppArmor isn't aimed at defending Windows desktop users; it is aimed at
defending Linux servers.  A pretty different environment, I'd say.

Ultimately, there are some things AppArmor may be good at, and there
are also sure to be some things it is bloody useless for.  My hammer
isn't very good for screwing in screws, but I still find it useful.
I confess I don't understand the kvetching about AppArmor's goals.
What are you expecting, some kind of silver bullet?

A question I'd find more interesting is whether AppArmor is able to
meet its stated goals, under a reasonable threat model, and with what
degree of assurance, and at what cost.  But I don't know whether that's
relevant for the linux-kernel mailing list.
