Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbXKMUjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbXKMUjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758948AbXKMUiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:38:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:5277 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbXKMUiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:38:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=FFVhCAGWtUD4ug3kor+5H+60raDjmjiPUwSCNtIGqoOmag6aKz76FNX0jkMULXohLtiFRVnjr4cs30P75gZ9x4htRF3bA7Xs2GGjF7Uy43wdXbXjs1zgQ9NduCzTGYoRc2kut6H+RlYH96Y65ZeTF5O/21mwjPhFF7wEx125fOc=
Message-ID: <473A0B57.4030703@googlemail.com>
Date: Tue, 13 Nov 2007 21:38:47 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-ide@vger.kernel.org, Alan Cox <alan@redhat.com>
Subject: [PATCH] pata_sis.c: Add Packard Bell EasyNote K5305 to laptops
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With newer kernels HDD in my old laptop is limited to UDMA 33.
With this patch I get UDMA 100 again.

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 3b5be77..87546d9 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -55,6 +55,7 @@ static const struct sis_laptop sis_laptop[] = {
 	/* devid, subvendor, subdev */
 	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
 	{ 0x5513, 0x1734, 0x105F },	/* FSC Amilo A1630 */
+	{ 0x5513, 0x1071, 0x8640 },     /* EasyNote K5305 */
 	/* end marker */
 	{ 0, }
 };
