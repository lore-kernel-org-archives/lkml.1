Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZKARWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZKARWH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 12:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZKARWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 12:22:05 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:36321 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbZKARWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 12:22:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=h1R7H/PUmF0NJF1Tovj6vzr+yx3yc5kxlRefeknU818Sn35A+gCpuP8uCy9Qn6hBkR
         6YZbNZbaN0wyyEXxH/7OVxCQy/rX77lopQesL690znAeN4RdFBaFKv5nhs9nR9cL4VLs
         ZpUliPl9uCAL+4dmy9TFoI/IjFpFQ76G5E6B0=
MIME-Version: 1.0
In-Reply-To: <4AED7DFC.2030504@s5r6.in-berlin.de>
References: <b8bf37780910310242v46cca93dl6d2c13d286085b1b@mail.gmail.com> 
	<4AED7DFC.2030504@s5r6.in-berlin.de>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sun, 1 Nov 2009 15:21:48 -0200
Message-ID: <b8bf37780911010921o12f3e890k931795f351af4dea@mail.gmail.com>
Subject: Re: [PATCH 16/16] trivial: fix assorted spelling typos
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>,
       me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 1, 2009 at 10:24 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> André Goddard Rosa wrote:
>> --- a/security/selinux/ss/services.c
>> +++ b/security/selinux/ss/services.c
>> @@ -741,7 +741,7 @@ int security_bounded_transition(u32 old_sid, u32 new_sid)
>>               goto out;
>>       }
>>
>> -     /* type/domain unchaned */
>> +     /* type/domain unchained */
>>       if (old_context->type == new_context->type) {
>>               rc = 0;
>>               goto out;
>
> unchanged?

Yes, of course you're right, thanks! Please find updated patch below:


>From 2299c361c4c789e822ccf3036ab9bbee05b3eb22 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 15:15:16 -0200
Subject: [PATCH 16/16] trivial: fix assorted spelling typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 arch/mips/include/asm/mach-pnx833x/gpio.h   |    2 +-
 drivers/gpu/drm/drm_crtc.c                  |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c |    2 +-
 drivers/media/dvb/frontends/lgdt330x.c      |    4 ++--
 drivers/net/ucc_geth.c                      |    2 +-
 drivers/staging/rtl8192su/r8192S_phy.c      |    2 +-
 drivers/watchdog/machzwd.c                  |    2 +-
 net/irda/irlmp.c                            |    2 +-
 security/selinux/ss/services.c              |    2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/mips/include/asm/mach-pnx833x/gpio.h
b/arch/mips/include/asm/mach-pnx833x/gpio.h
index 8de0eb9..ed3a88d 100644
--- a/arch/mips/include/asm/mach-pnx833x/gpio.h
+++ b/arch/mips/include/asm/mach-pnx833x/gpio.h
@@ -24,7 +24,7 @@

 /* BIG FAT WARNING: races danger!
    No protections exist here. Current users are only early init code,
-   when locking is not needed because no cuncurency yet exists there,
+   when locking is not needed because no concurrency yet exists there,
    and GPIO IRQ dispatcher, which does locking.
    However, if many uses will ever happen, proper locking will be needed
    - including locking between different uses
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 0321889..3f7c500 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -272,7 +272,7 @@ EXPORT_SYMBOL(drm_mode_object_find);
  * functions & device file and adds it to the master fd list.
  *
  * RETURNS:
- * Zero on success, error code on falure.
+ * Zero on success, error code on failure.
  */
 int drm_framebuffer_init(struct drm_device *dev, struct drm_framebuffer *fb,
 			 const struct drm_framebuffer_funcs *funcs)
diff --git a/drivers/infiniband/hw/ipath/ipath_iba6110.c
b/drivers/infiniband/hw/ipath/ipath_iba6110.c
index 4bd39c8..37d12e5 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba6110.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba6110.c
@@ -381,7 +381,7 @@ static const ipath_err_t infinipath_hwe_htclnkbbyte1crcerr =
 #define IPATH_GPIO_SCL \
 	(1ULL << (_IPATH_GPIO_SCL_NUM+INFINIPATH_EXTC_GPIOOE_SHIFT))

-/* keep the code below somewhat more readonable; not used elsewhere */
+/* keep the code below somewhat more readable; not used elsewhere */
 #define _IPATH_HTLINK0_CRCBITS (infinipath_hwe_htclnkabyte0crcerr |	\
 				infinipath_hwe_htclnkabyte1crcerr)
 #define _IPATH_HTLINK1_CRCBITS (infinipath_hwe_htclnkbbyte0crcerr |	\
diff --git a/drivers/media/dvb/frontends/lgdt330x.c
b/drivers/media/dvb/frontends/lgdt330x.c
index 056387b..43971e6 100644
--- a/drivers/media/dvb/frontends/lgdt330x.c
+++ b/drivers/media/dvb/frontends/lgdt330x.c
@@ -479,7 +479,7 @@ static int lgdt3302_read_status(struct
dvb_frontend* fe, fe_status_t* status)
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
-		/* Need to undestand why there are 3 lock levels here */
+		/* Need to understand why there are 3 lock levels here */
 		if ((buf[0] & 0x07) == 0x07)
 			*status |= FE_HAS_CARRIER;
 		break;
@@ -520,7 +520,7 @@ static int lgdt3303_read_status(struct
dvb_frontend* fe, fe_status_t* status)
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
-		/* Need to undestand why there are 3 lock levels here */
+		/* Need to understand why there are 3 lock levels here */
 		if ((buf[0] & 0x07) == 0x07)
 			*status |= FE_HAS_CARRIER;
 		else
diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
index 4469f24..5e9adba 100644
--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -3798,7 +3798,7 @@ static int ucc_geth_probe(struct of_device*
ofdev, const struct of_device_id *ma
 		prop = of_get_property(np, "tx-clock", NULL);
 		if (!prop) {
 			printk(KERN_ERR
-				"ucc_geth: mising tx-clock-name property\n");
+				"ucc_geth: missing tx-clock-name property\n");
 			return -EINVAL;
 		}
 		if ((*prop < QE_CLK_NONE) || (*prop > QE_CLK24)) {
diff --git a/drivers/staging/rtl8192su/r8192S_phy.c
b/drivers/staging/rtl8192su/r8192S_phy.c
index b8d4c43..77ab026 100644
--- a/drivers/staging/rtl8192su/r8192S_phy.c
+++ b/drivers/staging/rtl8192su/r8192S_phy.c
@@ -2711,7 +2711,7 @@ u8 rtl8192_phy_SwChnl(struct net_device* dev, u8 channel)
 // However, this procedure is performed synchronously  which should
be running under
 // passive level.
 //
-//not understant it
+//not understand it
 void PHY_SwChnlPhy8192S(	// Only called during initialize
 	struct net_device* dev,
 	u8		channel
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index b6b3f59..47d7197 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -21,7 +21,7 @@
  *      wd#1 - 2 seconds;
  *      wd#2 - 7.2 ms;
  *  After the expiration of wd#1, it can generate a NMI, SCI, SMI, or
- *  a system RESET and it starts wd#2 that unconditionaly will RESET
+ *  a system RESET and it starts wd#2 that unconditionally will RESET
  *  the system when the counter reaches zero.
  *
  *  14-Dec-2001 Matt Domsch <Matt_Domsch@dell.com>
diff --git a/net/irda/irlmp.c b/net/irda/irlmp.c
index c1ffe6d..0e7d8bd 100644
--- a/net/irda/irlmp.c
+++ b/net/irda/irlmp.c
@@ -105,7 +105,7 @@ int __init irlmp_init(void)

 	init_timer(&irlmp->discovery_timer);

-	/* Do discovery every 3 seconds, conditionaly */
+	/* Do discovery every 3 seconds, conditionally */
 	if (sysctl_discovery)
 		irlmp_start_discovery_timer(irlmp,
 					    sysctl_discovery_timeout*HZ);
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index ff17820..5914eeb 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -741,7 +741,7 @@ int security_bounded_transition(u32 old_sid, u32 new_sid)
 		goto out;
 	}

-	/* type/domain unchaned */
+	/* type/domain unchanged */
 	if (old_context->type == new_context->type) {
 		rc = 0;
 		goto out;
-- 
1.6.5.2.140.g5f809
