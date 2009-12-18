Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZLRJmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZLRJmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 04:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZLRJmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 04:42:37 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:42912 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZLRJmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:42:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O0srBwu/eSxqru+OD3nwxhFkGBkhXGaq/AcrHTtjO/FxnPYvy9l94jqs70bMWwcKBN
         OS3hPcaBK1M585pMXoClxiGH+Hop8eSYiXs9yP7Jt6M5JDzXmvXwuCZtTfGqtmXpHaE5
         QqjT3T+FZSSyteS5KX2YZWHu5C5LpdrqYC+Oo=
MIME-Version: 1.0
In-Reply-To: <20091218093132.4415.23424.sendpatchset@localhost.localdomain>
References: <20091218093132.4415.23424.sendpatchset@localhost.localdomain>
Date: Fri, 18 Dec 2009 17:42:34 +0800
Message-ID: <7b6bb4a50912180142u5e66fa88odb7cd3b6fa1a2ba2@mail.gmail.com>
Subject: Re: [Patch] thinkpad_acpi: fix a build error
From: Xiaotian Feng <xtfeng@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Corentin Chary <corentincj@iksaif.net>,
       ibm-acpi-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, akpm@linux-foundation.org,
       helight.xu@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo already sent this patch yesterday.
http://lkml.org/lkml/2009/12/17/25


On Fri, Dec 18, 2009 at 5:28 PM, Amerigo Wang <amwang@redhat.com> wrote:
>
> This patch fixes the following build error:
>
>  Building modules, stage 2.
>  MODPOST 1834 modules
> ERROR: "snd_card_create" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
> ERROR: "snd_ctl_notify" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
> ERROR: "snd_ctl_boolean_mono_info" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
> ERROR: "snd_ctl_new1" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
> ERROR: "snd_card_free" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
> ERROR: "snd_card_register" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
> ERROR: "snd_ctl_add" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Corentin Chary <corentincj@iksaif.net>
> Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Reported-by: Helight.Xu <helight.xu@gmail.com>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Tested-by: Helight.Xu <helight.xu@gmail.com>
>
> ---
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index fc5bf9d..596966c 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -215,6 +215,7 @@ config THINKPAD_ACPI
>        depends on ACPI
>        depends on INPUT
>        depends on RFKILL || RFKILL = n
> +       depends on SOUND
>        select BACKLIGHT_LCD_SUPPORT
>        select BACKLIGHT_CLASS_DEVICE
>        select HWMON
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
