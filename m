Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbZIMNow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbZIMNow (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 09:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZIMNor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 09:44:47 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:43715 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbZIMNoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 09:44:46 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=7aL8QoKEyJsA:10 a=w4iE+TBsmj5y1WloLYF40w==:17
 a=ULMWahI2Lg760u-EGLQA:9 a=S9yS_lCc-0GTMMX_5_pAARpMZMAA:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: mmc0: Timeout waiting for hardware interrupt.
Date: Sun, 13 Sep 2009 07:44:47 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909130744.47312.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got the following from inserting a plain old 2G SD card into my Lenovo SL500 
laptop:

[177156.720126] mmc0: Timeout waiting for hardware interrupt.
[177156.720129] sdhci: ============== REGISTER DUMP ==============
[177156.720134] sdhci: Sys addr: 0x1c512d8c | Version:  0x00000400
[177156.720137] sdhci: Blk size: 0x00007008 | Blk cnt:  0x00000001
[177156.720141] sdhci: Argument: 0x00000000 | Trn mode: 0x00000013
[177156.720144] sdhci: Present:  0x01ff0206 | Host ctl: 0x00000001
[177156.720147] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[177156.720150] sdhci: Wake-up:  0x00000000 | Clock:    0x00008007
[177156.720153] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[177156.720162] sdhci: Int enab: 0x02ff00cb | Sig enab: 0x02ff00cb
[177156.720165] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[177156.720168] sdhci: Caps:     0x01e021a1 | Max curr: 0x00000040
[177156.720170] sdhci: ===========================================
[177156.723183] mmc0: error -110 whilst initialising SD card

Once I removed and re inserted the card it started working, but I thought I'd 
report it.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
