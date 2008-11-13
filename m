Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbYKMXpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbYKMXpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYKMXpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:45:32 -0500
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:62782 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbYKMXpb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:45:31 -0500
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: linux-kernel@vger.kernel.org
Subject: build error with 2.6.27.6+reiser4+ehci-hub patch. ERROR: "mii_ethtool_gset" [drivers/net/r8169.ko] undefined!
Date: Fri, 14 Nov 2008 00:45:19 +0100
User-Agent: KMail/1.10.90 (Linux/2.6.27.5r4; KDE/4.1.73; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, stable@kernel.org, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811140045.20166.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
with my old config from 2.6.27.5 (which has the same patches) I get this 
error:
make all modules_install install
<snip>
  OBJCOPY arch/x86/boot/setup.bin
  OBJCOPY arch/x86/boot/vmlinux.bin
  HOSTCC  arch/x86/boot/tools/build
  BUILD   arch/x86/boot/bzImage
Root device is (9, 1)
Setup is 11436 bytes (padded to 11776 bytes).
System is 2180 kB
CRC 54816509
Kernel: arch/x86/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 136 modules
ERROR: "mii_ethtool_gset" [drivers/net/r8169.ko] undefined!
make[1]: *** [__modpost] Fehler 1
make: *** [modules] Fehler 2

Glück Auf,
Volker
