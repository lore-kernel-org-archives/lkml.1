Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab0CCHVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:21:35 -0500
Received: from mtumx-2.merit.edu ([198.108.1.20]:27021 "EHLO mail.mtu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750799Ab0CCHVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:21:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAOycjUuN208i/2dsb2JhbACFY8caDYRgiFqEewSDF4sf
X-IronPort-AV: E=Sophos;i="4.49,572,1262581200"; 
   d="scan'208";a="273812361"
Message-ID: <4B8E0DFE.2040603@mtu.edu>
Date: Wed, 03 Mar 2010 02:21:34 -0500
From: Jakob Penzien <jwpenzie@mtu.edu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de, wfp5p@virginia.edu, bart@cs.pdx.edu,
       linux@dominikbrodowski.net, keil@b1-systems.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH: ni_labpc_cs.c 2
References: <4B8DF681.4050903@mtu.edu>
In-Reply-To: <4B8DF681.4050903@mtu.edu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

- From b8eff3ab872920c733981fa475220c0b6169d058 Mon Sep 17 00:00:00 2001
From: Jakob Penzien <jakob@bloodmoon.(none)>
Date: Wed, 3 Mar 2010 00:31:24 -0500
Subject: [PATCH 2/2] Staging: Comedi: fix 80 character and KERN
coding style issue in ni_labpc_cs.c
 This is a patch to the ni_labpc_cs.c file that fixes up the 80
character and KERN
 warning found by the checkpoint.pl tool. Changed the spaceing
between KERN and ".
 Signed-off-by: Jakob Penzien <Supermine290@gmail.com>

- ---
 drivers/staging/comedi/drivers/ni_labpc_cs.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc_cs.c
b/drivers/staging/comedi/drivers/ni_labpc_cs.c
index 0b963bb..07d7bf9 100644
- --- a/drivers/staging/comedi/drivers/ni_labpc_cs.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_cs.c
@@ -1,7 +1,8 @@
 /*
     comedi/drivers/ni_labpc_cs.c
     Driver for National Instruments daqcard-1200 boards
- -    Copyright (C) 2001, 2002, 2003 Frank Mori Hess
<fmhess@users.sourceforge.net>
+    Copyright (C) 2001, 2002, 2003 Frank Mori Hess
+    <fmhess@users.sourceforge.net>

     PCMCIA crap is adapted from dummy_cs.c 1.31 2001/08/24 12:13:13
     from the pcmcia package.
@@ -146,7 +147,7 @@ static int labpc_attach(struct comedi_device
*dev, struct comedi_devconfig *it)
 		irq = link->irq.AssignedIRQ;
 		break;
 	default:
- -		printk("bug! couldn't determine board type\n");
+		printk(KERN_ERR "bug! couldn't determine board type\n");
 		return -EINVAL;
 		break;
 	}
- --
1.6.3.3
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkuODfoACgkQRHWk8kRA7BAM1QCeKMICZDu19e8DQfyS4UsSRn62
+jUAoIJ91y4SRk+S7+eXALvP/2hB1Vm0
=OYrU
-----END PGP SIGNATURE-----
