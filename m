Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbZC3Lnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbZC3Lnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 07:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZC3LnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 07:43:22 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39940 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZC3LnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 07:43:21 -0400
Date: Mon, 30 Mar 2009 12:12:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
Cc: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Theodore Tso <tytso@mit.edu>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090330121216.2a9be61f@the-village.bc.nu>
In-Reply-To: <49D0A3D6.4000300@ursus.ath.cx>
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
	<20090330100546.51907bd2@the-village.bc.nu>
	<49D0A3D6.4000300@ursus.ath.cx>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You surely know that better: Did fs actually write "later" data quite
> long before "earlier" data? During the flush data may be re-ordered, but
> was it also _done_ outside of it?

BSD FFS/UFS and earlier file systems could leave you with all sorts of
ordering that was not guaranteed - you did get data written within about
30 seconds but no order guarantees and a crash/fsck could give you
interesting partial updates .. really interesting.

renaming was one fairly safe case as BSD FFS/UFS did rename synchronously
for the most part.

