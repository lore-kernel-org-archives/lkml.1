Return-Path: <linux-kernel-owner+w=401wt.eu-S2992546AbXCBP61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992546AbXCBP61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992550AbXCBP60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:58:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:34974 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992546AbXCBP6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:58:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ibm4pLrKM+2KOb92h99rj/dis0yG/jur+bFE3rGSczHa8BsSoNTYA+BWjPPu17FyihwF+FrYYfsckMflp2INN9YQNfWArVUHPPEpCdMpPzdERP84uAwMaEgd83byl8G6aoT0vqSoreRlI2t2Msu5smf1fAEjxGMA1NU/D6jQK0Q=
Message-ID: <45E8493A.8020507@googlemail.com>
Date: Fri, 02 Mar 2007 16:56:42 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Antonino Daplas <adaplas@gmail.com>
Subject: Re: 2.6.21-rc2-mm1
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton napisał(a):
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> 

Possible fix for

nvidiafb-bring-back-generic-ddc-reading.patch

drivers/built-in.o: In function `nvidia_probe_i2c_connector':
/mnt/md0/devel/linux-mm/drivers/video/nvidia/nv_i2c.c:166: undefined reference to `fb_ddc_read'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [_all] Error 2

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work/drivers/video/Makefile	2007-03-02 16:38:17.000000000 +0100
+++ linux-mm/drivers/video/Makefile	2007-03-02 16:49:23.000000000 +0100
@@ -33,6 +33,7 @@ obj-$(CONFIG_FB_PM3)		  += pm3fb.o
 obj-$(CONFIG_FB_MATROX)		  += matrox/
 obj-$(CONFIG_FB_RIVA)		  += riva/ vgastate.o
 obj-$(CONFIG_FB_NVIDIA)		  += nvidia/
+obj-$(CONFIG_FB_NVIDIA_I2C)	  += fb_ddc.o
 obj-$(CONFIG_FB_ATY)		  += aty/ macmodes.o
 obj-$(CONFIG_FB_ATY128)		  += aty/ macmodes.o
 obj-$(CONFIG_FB_RADEON)		  += aty/
