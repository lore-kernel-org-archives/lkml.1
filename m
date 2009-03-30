Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbZC3Jhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbZC3Jhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 05:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbZC3Jh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 05:37:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48790 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbZC3Jh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 05:37:29 -0400
Date: Mon, 30 Mar 2009 10:05:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
Cc: Theodore Tso <tytso@mit.edu>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090330100546.51907bd2@the-village.bc.nu>
In-Reply-To: <49D0710A.1030805@ursus.ath.cx>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
	<alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
	<49CD7B10.7010601@garzik.org>
	<49CD891A.7030103@rtr.ca>
	<49CD9047.4060500@garzik.org>
	<49CE2633.2000903@s5r6.in-berlin.de>
	<49CE3186.8090903@garzik.org>
	<49CE35AE.1080702@s5r6.in-berlin.de>
	<49CE3F74.6090103@rtr.ca>
	<20090329231451.GR26138@disturbed>
	<20090330003948.GA13356@mit.edu>
	<49D0710A.1030805@ursus.ath.cx>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems you still didn't get the point. ext3 data=ordered is not the
> problem. The problem is that the average developer doesn't expect the fs
> to _re-order_ stuff. This is how most common fs did work long before

No it isn´t. Standard Unix file systems made no such guarantee and would
write out data out of order. The disk scheduler would then further
re-order things.

If you think the ¨guarantees¨ from before ext3 are normal defaults you´ve
been writing junk code

