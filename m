Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbZGHUIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbZGHUIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbZGHUIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:08:12 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46649 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbZGHUIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:08:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=V8p05fNDl0h4UecwhwvKwx4RW+5KfQjE3p4FRBAVB49MexSWeb1lgf9my84Q5aCFQa
         okPQ+KvIrkIiE5X/4bCZFS/4OYLcotl6XvEz3OKgoTSjNOdEaot/sK0pxyLAyjUYeSgP
         Wk8b2ma/+8RT5wqueBMcRRpq613/pzU+k/bnA=
Message-ID: <4A54FC6B.7000003@gmail.com>
Date: Wed, 08 Jul 2009 22:07:07 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] staging/rt3070: add support for Linksys WUSB54GC-EU v3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to FCC (*1) and *2 there's really RT2070L inside, but according
to *2 RT3070 and RT2070 are compatible.

*1 https://fjallfoss.fcc.gov/oetcf/eas/reports/ViewExhibitReport.cfm?mode=Exhibits&RequestTimeout=500&calledFromFrame=N&application_id=327783&fcc_id=%27Q87-WUSB54GCV3%27
(look for "Internal Photos")
*2 http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=5&t=5245

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/rt2870/rt2870.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rt2870/rt2870.h b/drivers/staging/rt2870/rt2870.h
index 5e5b3f2..9679ccb 100644
--- a/drivers/staging/rt2870/rt2870.h
+++ b/drivers/staging/rt2870/rt2870.h
@@ -215,6 +215,7 @@
 	{USB_DEVICE(0x0789,0x0163)}, /* Logitec 2870 */		\
 	{USB_DEVICE(0x0789,0x0164)}, /* Logitec 2870 */		\
 	{USB_DEVICE(0x1EDA,0x2310)}, /* AirTies 3070 */		\
+	{USB_DEVICE(0x1737,0x0077)}, /* Linksys WUSB54GC-EU v3 */	\
 	{ }/* Terminating entry */                      \
 }
 #endif
-- 
1.6.3.3

