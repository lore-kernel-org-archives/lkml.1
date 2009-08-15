Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZHOLgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZHOLgC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 07:36:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZHOLgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 07:36:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:57903 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbZHOLgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 07:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=sqctxdcl+3IQzOGq/VVteRqMcIXhdfJv2hhD6szZI0NRHfZpY4s5VtYgZSrxNNT7HV
         r+dOcSaSxPayO8seL1xcXgzHjFa59XKfua4FNMsKKHj8dOMdZyRjd5h4589WneaOmrrj
         aLsgI9HNFq8PtopXODB1FGvJJ7isqQ6/VNpuU=
Message-ID: <4A869D9B.9040800@gmail.com>
Date: Sat, 15 Aug 2009 19:35:55 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 7/9] ARM: rename function of clock select file to nuc900
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

Rename function of clock select file to nuc900, due to it is
common API, it should not be named after specific CPU.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/clksel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-w90x900/clksel.c b/arch/arm/mach-w90x900/clksel.c
index 5a77eb9..1d451f3 100644
--- a/arch/arm/mach-w90x900/clksel.c
+++ b/arch/arm/mach-w90x900/clksel.c
@@ -59,7 +59,7 @@ static void clock_source_select(const char *dev_id, unsigned int clkval)
 	__raw_writel(clksel, REG_CLKSEL);
 }
 
-void w90p910_clock_source(struct device *dev, unsigned char *src)
+void nuc900_clock_source(struct device *dev, unsigned char *src)
 {
 	unsigned int clkval;
 	const char *dev_id;
@@ -87,5 +87,5 @@ void w90p910_clock_source(struct device *dev, unsigned char *src)
 
 	mutex_unlock(&clksel_sem);
 }
-EXPORT_SYMBOL(w90p910_clock_source);
+EXPORT_SYMBOL(nuc900_clock_source);
 
-- 
1.5.6.3

