Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbZLRNVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbZLRNVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZLRNVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:21:45 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:61477 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbZLRNVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:21:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=xf0Z1EuUnblNKP9IcFf0Ce1C+babfr4RMWEdlvUwBbMLzFyL9/Rn1lKFz4wFUKno1V
         QX7xkxXw7ijQOsqdJxiussfQswzaNCwc3WUVVCV9z41XqqoyHbcWIOzU3NMr4K68dRM2
         I114WkBvZsvGH/z8VJoYUzVBYAg52u9UnNIaA=
Message-ID: <4B2B8261.9000105@gmail.com>
Date: Fri, 18 Dec 2009 21:23:45 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: ibm-acpi-devel@lists.sourceforge.net,
       =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] thinkpad_acpi: fix a build error
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

 Building modules, stage 2.
 MODPOST 1834 modules
ERROR: "snd_card_create" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_ctl_notify" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_ctl_boolean_mono_info" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_ctl_new1" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_card_free" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_card_register" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_ctl_add" [drivers/platform/x86/thinkpad_acpi.ko] undefined!



Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Helight.Xu <helight.xu@gmail.com>
Tested-by: Helight.Xu 
<helight.xu@gmail.com>                                                    
---
 drivers/platform/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index fc5bf9d..cda6fb6 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -215,6 +215,7 @@ config THINKPAD_ACPI
        depends on ACPI
        depends on INPUT
        depends on RFKILL || RFKILL = n
+       depends on SND
        select BACKLIGHT_LCD_SUPPORT
        select BACKLIGHT_CLASS_DEVICE
        select HWMON
-- 
1.6.5.3

-- 
Zhenwen Xu - Seven Helight
Home Page: http://zhwen.org

