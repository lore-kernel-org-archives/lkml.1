Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYL2MNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYL2MNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYL2MNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:13:12 -0500
Received: from g130.green.fastwebserver.de ([85.114.128.130]:8171 "EHLO
	g130.green.fastwebserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775AbYL2MNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:13:11 -0500
X-Greylist: delayed 1789 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2008 07:13:11 EST
From: Andreas Demmer <mail@andreas-demmer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] wider hardware support for GSPCA VC032x driver, kernel 2.6.27
Date: Mon, 29 Dec 2008 12:43:10 +0100
User-Agent: KMail/1.10.92 (Linux/2.6.27.7-9-pae; KDE/4.1.85; i686; ; )
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAElBMVEW8gnPv1dNAJx3lsZmV
 TkTblIamj2dcAAACZklEQVQ4jV2US5LbMAxEuyxyb42SvcLoAJJh7BkVtUeZ4v2vMg3KqZkE
 5V/pEf+mURBVZBu7TSIqGi3sCQT1O5DaDOhg+BfQxTqI9gVGAmlmuThozCF/gSNFKP+FGrcO
 DATZc8u3SDR8gW7jqFL5as1D5RZrrSvQ6jYJv8Hkoez0iI2V5AAhQCkl8H2FUu/RSpVJizsg
 JAcBbvzMbd1n5Mzze0pY+IQhU8Ftxr7gllIq/AC/4SDkh0yv+bylW8rh3DEjIuRXwnEbhE6v
 FHaGL1hyPgBRlcegr1lYcUEIu+c4orUGCYOc2cfBnPA+FMa+6sq6T2R2stPFAdtrtQrbFDuG
 WtWC58gDx1l9XjqoZccS4YCjkGusKhb6EeEKuai6XcPl4ZOj5AFttrOmvqdpvMBxLZfJT7wX
 uA4yNcQe8yR4Bnr78rRtBH5MqnG6Jwb3oH914NWLshc8YdozN+ZgB4f/AsGZ3VubGhVWUsoc
 jzl4ZjRvUZ5p4fN0DLFFByuXLo1e6udLbuwCrkTNEdZrIWEciz1UgjAUf7PmKrwQLnV0UVs+
 TJVIr3lF4yIClz+efnN6M+yf8YHYAuUy/jioKnWtxGYunCxrSL8J4PUKBXQZVoov/cJ4zxUU
 J/t1Q2D1ZwdjNtPNm6/cA5c3CO/mH4LiI52EmifkjR1WZnKPwJsg/SIzVGSz65I6eOQY+qY5
 DJUYPEUHH4vHfZuuzVN4ueM9xRj7TetKgfqQE8HPNPsUt+sPoPatdDDtS2xDv7mTtNVCeoOx
 pNl1NlFEdOBk3+Deh3ypy9fuj3cHHzmkpUuQtpo7cMmfy1PEzLdeSRkAAAAASUVORK5CYII=
MIME-Version: 1.0
Content-Disposition: inline
X-Original-Status: R
X-Original-X-Status: NT
X-Original-X-UID: 0
X-Length: 3156
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200812291243.10416.mail@andreas-demmer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds support for built-in "Logitech QuickCam for Dell notebooks" 
webcams.

Basically,  I just added a new USB ID (046d:0897) to the list of supported 
devices with the VIMICRO chip. The hardware seems to be pretty identical to 
046d:0896 but features a different USB ID.

---------------------------------------------------------------------------
--- drivers/media/video/gspca/vc032x.c.orig     2008-12-27 18:06:49.000000000 
+0100
+++ drivers/media/video/gspca/vc032x.c  2008-12-27 18:09:10.000000000 +0100
@@ -1740,6 +1740,7 @@
 static const __devinitdata struct usb_device_id device_table[] = {
        {USB_DEVICE(0x046d, 0x0892), .driver_info = BRIDGE_VC0321},
        {USB_DEVICE(0x046d, 0x0896), .driver_info = BRIDGE_VC0321},
+       {USB_DEVICE(0x046d, 0x0897), .driver_info = BRIDGE_VC0321},
        {USB_DEVICE(0x0ac8, 0x0321), .driver_info = BRIDGE_VC0321},
        {USB_DEVICE(0x0ac8, 0x0323), .driver_info = BRIDGE_VC0323},
        {USB_DEVICE(0x0ac8, 0x0328), .driver_info = BRIDGE_VC0321},
---------------------------------------------------------------------------

I tested it very thoroughly with my Dell XPS M2010 notebook and it works 
just fine.

Please CC comments to: mail (at) andreas-demmer (dot) de

Best regards,
Andreas Demmer

-- 
Andreas Demmer

Skype:   andreas.demmer
ICQ:     103 924 771

http://www.andreas-demmer.de


