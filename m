Return-Path: <linux-kernel-owner+w=401wt.eu-S1761415AbYGAV5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761415AbYGAV5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYGAV53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:57:29 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:54028 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751862AbYGAV53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:57:29 -0400
Date: Tue, 1 Jul 2008 22:57:26 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: RFC: Add mtdset= to Documentation/kernel-parameters
Message-ID: <20080701215726.GA22880@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anyone have any comments about adding this patch
to describe the ARM/S3C2412 Jive machine specific kernel
commandline parameter mtdset?

--- linux-2.6.26-rc8-next20080630/Documentation/kernel-parameters.txt	2008-07-01 15:06:47.000000000 +0100
+++ linux-2.6.26-rc8-next20080630-jivecmdline/Documentation/kernel-parameters.txt	2008-07-01 22:54:56.000000000 +0100
@@ -1235,6 +1235,11 @@ and is between 256 and 4096 characters. 
 	mtdparts=	[MTD]
 			See drivers/mtd/cmdlinepart.c.
 
+	mtdset=		[ARM]
+			ARM/S3C2412 JIVE boot control
+
+			See arch/arm/mach-s3c2412/mach-jive.c
+
 	mtouchusb.raw_coordinates=
 			[HW] Make the MicroTouch USB driver use raw coordinates
 			('y', default) or cooked coordinates ('n')

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
