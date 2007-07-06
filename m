Return-Path: <linux-kernel-owner+w=401wt.eu-S1763034AbXGFHOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763034AbXGFHOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760237AbXGFHOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:14:05 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:54547 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbXGFHOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:14:04 -0400
To: nigel@suspend2.net
CC: rjw@sisk.pl, pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       nigel@suspend2.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org, oliver@neukum.org,
       paulus@samba.org, miklos@szeredi.hu, mingo@elte.hu
In-reply-to: <200707061707.23316.nigel@nigel.suspend2.net> (message from Nigel
	Cunningham on Fri, 6 Jul 2007 17:07:20 +1000)
Subject: Re: [RFC][PATCH -mm] PM: Do not sync filesystems from within the freezer
References: <200707041658.59588.rjw@sisk.pl> <20070705220046.GC3881@elf.ucw.cz> <200707060902.55090.rjw@sisk.pl> <200707061707.23316.nigel@nigel.suspend2.net>
Message-Id: <E1I6i0N-0003CY-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 06 Jul 2007 09:13:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> To get more serious and practical though, I think the solution is to
> fuzz the userspace/kernelspace distinction. What we really want to
> do is freeze things that submit I/O, then sync, then freeze anything
> that processes I/O and needs to be frozen. In effect, redefine fuse
> processes as freezeable kernel threads.

Another myth, that has been debunked already.  The problem is: how do
you define fuse processes?  There's no theoretical or even practial
way to do that.

Miklos
