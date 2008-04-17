Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbYDQMlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbYDQMlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 08:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbYDQMlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 08:41:03 -0400
Received: from nef2.ens.fr ([129.199.96.40]:2134 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739AbYDQMlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 08:41:00 -0400
X-Greylist: delayed 1700 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Apr 2008 08:41:00 EDT
Date: Thu, 17 Apr 2008 14:12:38 +0200
From: David Madore <david.madore@ens.fr>
To: Linux Kernel Mailing-List <linux-kernel@vger.kernel.org>
Subject: does pata_marvell (88SE6145 driver) support external SATA port?
Message-ID: <20080417121238.GA29263@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Thu, 17 Apr 2008 14:12:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an Asus P5W64 WS motherboard, featuring a Marvell 88SE6145 ATA
controller, with three internal SATA ports and one external e-SATA
port.  I understand the Linux kernel driver for this controller is
called pata_marvell even though it's a SATA controller (/me confused,
but I think it says something like the controller is used in "legacy"
mode, whatever that means); I also understand that this driver will
not drive the third internal SATA port (reported on, e.g., <URL:
http://ubuntuforums.org/archive/index.php/t-507061.html
 >): this is coherent with Alan Cox's comment when signing of the
driver (<URL: http://lkml.org/lkml/2006/10/16/157 >) that the driver
will "drive the SATA ports 1 & 2 in legacy mode".  However, no mention
was made of the external SATA port.

So:

Does the pata_marvell module support an external SATA port?

How can I know this without buying an external SATA drive and
discovering to my dismay that I can't use it? :-)

Cheers,

-- 
     David A. Madore
    (david.madore@ens.fr,
     http://www.madore.org/~david/ )
