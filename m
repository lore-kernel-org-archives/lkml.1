Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbXKMUfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbXKMUfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbXKMUfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:35:46 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:3803 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbXKMUfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:35:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=JHt4SATZTc4+/2YoisD6K1N1BFvMurvOYQ2tAqCGkzEQb0G3Qmt2v6O62psgbBKZ/GTW9I5mACwSLxUJo0Xj5V/xdceSPPELTEjkp3Lky/3hjQgo9/s4NOa288jl3EkdcmRR2aOJ87unf3U7gJmvR6LSegqWldjrRH8Z4SkjX10=
Message-ID: <473A0A9B.5000104@googlemail.com>
Date: Tue, 13 Nov 2007 21:35:39 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] sis5513.c: Add Packard Bell EasyNote K5305 to laptops
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With newer kernels HDD in my old laptop is limited to UDMA 33.
With this patch I get UDMA 100 again.

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 6b7bb53..3878224 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -527,6 +527,7 @@ static const struct sis_laptop sis_laptop[] = {
 	/* devid, subvendor, subdev */
 	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
 	{ 0x5513, 0x1734, 0x105f },	/* FSC Amilo A1630 */
+	{ 0x5513, 0x1071, 0x8640 },     /* EasyNote K5305 */
 	/* end marker */
 	{ 0, }
 };

