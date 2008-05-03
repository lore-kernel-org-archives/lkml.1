Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbYECJIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbYECJIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 05:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757403AbYECJIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 05:08:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:57879 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125AbYECJIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 05:08:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=nqNCkSoQ9MdA8bra3sVbLeubpKoyuJdPPqGVdpJjxKBO/XL2yum9nQR+sviXrYQRmZW33DiCKKkJ6CRU+TzzDy8RLve1xJVvp+7fRe58Vd8OmP6XLz+6bBQQ7yDOaWdYFV9jGwkrez5Db9Y4cNv377Eq0JPkHrWJXCLa1okgCfM=
Date: Sat, 3 May 2008 14:03:18 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, rmk@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] arm-lubbock: fix compilation
Message-ID: <20080503100318.GA5007@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-pxa/lubbock.c:399: error: expected '}' before ';' token

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/arm/mach-pxa/lubbock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-pxa/lubbock.c
+++ b/arch/arm/mach-pxa/lubbock.c
@@ -396,7 +396,7 @@ static struct pxafb_mach_info sharp_lm8v31 = {
 	.cmap_inverse	= 0,
 	.cmap_static	= 0,
 	.lcd_conn	= LCD_COLOR_DSTN_16BPP | LCD_PCLK_EDGE_FALL |
-			  LCD_AC_BIAS_FREQ(255);
+			  LCD_AC_BIAS_FREQ(255),
 };
 
 #define	MMC_POLL_RATE		msecs_to_jiffies(1000)

