Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZBSUtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZBSUtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757717AbZBSUtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:49:06 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:40768 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbZBSUtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:49:04 -0500
Date: Thu, 19 Feb 2009 21:49:02 +0100
From: Andreas Mohr <andi@lisas.de>
To: Jose Luis Marchetti <joseluismarchetti@yahoo.com.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is interrupt priority supported ?
Message-ID: <20090219204902.GA3990@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <657201.46675.qm@web34402.mail.mud.yahoo.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it has been for a looong time (those things tend to almost get outdated already -
witness the floppy controller misery):

# apt-cache show hwtools
Package: hwtools
Status: install ok installed
Priority: optional
Section: utils
Installed-Size: 312
Maintainer: Pierre Ancelot <eternityos@free.fr>
Architecture: i386
Version: 0.8-5.1
Depends: debconf, libc6 (>= 2.3.5-1)
Suggests: sysutils, hdparm, scsitools, memtest86
Conffiles:
 /etc/init.d/hwtools 137e3fbdc26d90bec745a36d1ffd8661
Description: collection of tools for low-level hardware management
 This package is a collection of tools useful for hardware
 troubleshooting and optimization (for ix86 machines):
 .
  irqtune: adjusts priority of interrupts (improves serial performance),
  scanport: scans for hardware not already handled by Linux drivers,
  memmxtest: a real mode memory test, with MMX support.  You may want
  to look at package memtest86 as well.
  qic-02 driver and configuration utilities. Adds the qic-02 tapes support
 .
 Be aware that these tools require some knowledge of what are they
 doing to be used properly, otherwise they may cause damage to your system.
 .
 Some programs that were previously part of this package have been
 moved to their own packages (hdparm, scsitools, memtest86)





I don't have any recent experience with irqtune myself, though, and I cannot
authoritatively state that it actually works at the moment,
but I'd be relatively surprised if it didn't.

You might want to enable some unfortunately often still default-disabled
hardware transceiver offloading of Ethernet frames, too, via ethtool -k or so,
to possibly reduce latency.

Plus PCI latency timings, via setpci or so (but that probably won't
matter).

HTHHAND,

Andreas Mohr
