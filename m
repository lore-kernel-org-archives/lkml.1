Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbXE0L5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbXE0L5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 07:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXE0L5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 07:57:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33029 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751303AbXE0L5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 07:57:41 -0400
Date: Sun, 27 May 2007 13:02:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tommy Vercetti <vercetti@zlew.org>
Cc: "Ray Lee" <ray-lk@madrabbit.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
Message-ID: <20070527130228.3731ff4d@the-village.bc.nu>
In-Reply-To: <200705271222.30169@gj-laptop>
References: <200705261505.38109@gj-laptop>
	<200705261746.01568@gj-laptop>
	<2c0942db0705260907g4e37d4avcc652d2b7368edd5@mail.gmail.com>
	<200705271222.30169@gj-laptop>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > That looks fine. Your filesystem may just be very fragmented. I'm not
> > familiar with how reiser3 filesystems age, so if you've had the system
> > installed for quite some time, it may be time to back it up and
> > reinstall. Dunno.
> yeah, and they say unix FSes don't need defragmentation.... my bottom...

Provided they don't get within about 5-10% of full a lot of the time Unix
file systems generally don't  - especially with preallocators. Reiser3 is
not a traditional unix file system, its very different to almost any
other fs, and it does need defragmenting.
