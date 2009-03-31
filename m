Return-Path: <linux-kernel-owner+w=401wt.eu-S1763523AbZCaVpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763523AbZCaVpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759480AbZCaVoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:44:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41649 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763505AbZCaVoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:44:54 -0400
Date: Tue, 31 Mar 2009 22:13:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Theodore Tso <tytso@mit.edu>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090331221335.686a959b@the-village.bc.nu>
In-Reply-To: <49D11BDD.70702@redhat.com>
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
	<49D0AA4A.6020308@redhat.com>
	<alpine.LFD.2.00.0903300817400.3948@localhost.localdomain>
	<49D0EF1E.9040806@redhat.com>
	<alpine.LFD.2.00.0903300922231.3948@localhost.localdomain>
	<49D0FD4C.1010007@redhat.com>
	<alpine.LFD.2.00.0903301038100.3948@localhost.localdomain>
	<49D11BDD.70702@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No argument there.  I have seen NCQ starvation on SATA disks,
> with some requests sitting in the drive for seconds, while
> the drive was busy handling hundreds of requests/second
> elsewhere...

The really sad thing about that one is that the SCSI vendors had this
problem over ten years ago with TCQ - and fixed it in the drives.

