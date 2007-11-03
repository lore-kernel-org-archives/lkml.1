Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbXKCNgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbXKCNgl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 09:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbXKCNgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 09:36:31 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:58224 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbXKCNga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 09:36:30 -0400
X-Greylist: delayed 2637 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Nov 2007 09:36:30 EDT
Subject: ne2k-pci 0000:05:00.0: no I/O resource at PCI BAR #0
From: Frederik Himpe <fhimpe@telenet.be>
To: linux-net@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=utf-8
Date: Sat, 03 Nov 2007 14:36:28 +0100
Message-Id: <1194096988.5873.8.camel@Anastacia>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.1-1mdv2008.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a new PC system to which I added a RTL-8029 PCI network card. The
card is recognised fine by lspci, but when loading the ne2k-pci module,
this error is given in dmesg:
ne2k-pci 0000:05:00.0: no I/O resource at PCI BAR #0

This happens with both 2.6.22.9 as with 2.6.23.1.

dmesg: http://artipc10.vub.ac.be/ne2k-pci/dmesg.txt
lspci -nn: ﻿http://artipc10.vub.ac.be/ne2k-pci/lspci-nn.txt
lspci -vvv: ﻿http://artipc10.vub.ac.be/ne2k-pci/lspci-vvv.txt

Is this a hardware problem, or is something going wrong in the kernel?
The BIOS is the latest version available for the Asus P5K-SE
motherboard.

-- 
Frederik Himpe



