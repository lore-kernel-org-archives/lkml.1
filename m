Return-Path: <linux-kernel-owner+w=401wt.eu-S937623AbXFGW20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937623AbXFGW20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936489AbXFGW2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:28:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33016 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764829AbXFGW2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:28:13 -0400
Date: Thu, 7 Jun 2007 23:32:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Jones <pjones@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607233258.063f6cfa@the-village.bc.nu>
In-Reply-To: <20070607200102.GA21653@suse.de>
References: <1181206091.3625.9.camel@lov.localdomain>
	<4667D2DF.30207@googlemail.com>
	<1181228660.3625.23.camel@lov.localdomain>
	<46682385.1060802@redhat.com>
	<20070607154342.GA16911@suse.de>
	<20070607085200.f8d6e2d3.akpm@linux-foundation.org>
	<20070607155953.GA17591@suse.de>
	<20070607090632.cfcf02e6.akpm@linux-foundation.org>
	<20070607161525.GA18363@suse.de>
	<20070607184805.GA28551@nostromo.devel.redhat.com>
	<20070607200102.GA21653@suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah, but the installer doesn't matter until you do a Fedora 8 release,
> right?  This is just for people who want to run their own kernel on an
> already-set-up Fedora machine.

People can and do roll updated install images because you get systems
that aren't supported by the released CD boot image. The installer/initrd
etc shouldn't keep getting broken by these kind of changes, its about
time that all the sysfs type breakage causing patches simply got
rejected, like such patches would in every other subsystem.

Yes it might cause a little pain, yes someone might have to tweak sysfs a
bit to keep compatibility and decouple the external and internal view a
bit - Matthew and others pointed out this problem several years ago and
predicted the current state of affairs, so its had a lot of time to get
fixed.

Alan
