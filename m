Return-Path: <linux-kernel-owner+w=401wt.eu-S1761610AbXE1KM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761610AbXE1KM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbXE1KMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:12:21 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:37733 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbXE1KMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:12:20 -0400
Message-ID: <1180350665.465ab8c9ee364@imp.free.fr>
Date: Mon, 28 May 2007 13:11:05 +0200
From: xcsnake@free.fr
To: linux-kernel@vger.kernel.org
Subject: 8 words bursts for fbdev driver
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 82.237.160.83
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm working on a FPGA vga controller, with an arm cpu (at91rm9200). My FPGA is
plugged on a 16 bits data bus. I'm trying to develop the framebuffer driver,
from the epson s1d13xxxfb driver to use my controller. I have a first driver
which works well. To accelerate my controller, I would like to read and write in
my video memory (controlled by the FPGA) by 8 words bursts. Is it possible to
tell the kernel that the memory must be accessed only by 8 words bursts ??
My driver is available on http://xcsnake.free.fr/driver

Thanks a lot
