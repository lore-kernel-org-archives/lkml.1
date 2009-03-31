Return-Path: <linux-kernel-owner+w=401wt.eu-S1761804AbZCaVma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761804AbZCaVma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760530AbZCaVmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:42:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41639 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759106AbZCaVmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:42:09 -0400
Date: Tue, 31 Mar 2009 22:10:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Theodore Tso <tytso@mit.edu>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090331221053.74354735@the-village.bc.nu>
In-Reply-To: <alpine.LFD.2.00.0903300922231.3948@localhost.localdomain>
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
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> percentage. For many setups, the other corruption issues (drive failure) 
> are not just more common, but generally more disastrous anyway. So why 
> would a person like that worry about the (rare) power failure?

How about the far more regular crash case ? We may be pretty reliable but
we are hardly indestructible especially on random boxes with funky BIOSes
or low grade hardware builds.

For the generic sane low end server/high end desktop build with at least
two drive software RAID the hardware failure for data loss case is
pretty rare. Crashes yes, having to reboot to recover from a RAID failure
sure but data loss far less so
