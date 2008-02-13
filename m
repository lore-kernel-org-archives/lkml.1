Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbYBMXDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbYBMXDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760319AbYBMXD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:03:29 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42199 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764510AbYBMXD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:03:27 -0500
X-Sasl-enc: nY2PNuX3AHXqHqeSWJd43FmX1ZQyaR47fzTNhKDc4gla 1202943805
Date: Wed, 13 Feb 2008 21:03:21 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Adrian Bunk <bunk@kernel.org>
Cc: Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] thinkpad_acpi.c: make 2 functions static
Message-ID: <20080213230321.GC26196@khazad-dum.debian.net>
References: <20080213213006.GV3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213213006.GV3383@cs181133002.pp.htv.fi>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Adrian Bunk wrote:
> this_patch_makes_the_needlessly_global_hotkey_wakeup_reason_notify_change_and_hotkey_wakeup_hotunplug_complete_notify_change_static
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> ;-)
> 
> da7d9b1a1d74ba5265d02e316a215540fe2daf19 diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
> index 7ba1aca..e2c7edd 100644
> --- a/drivers/misc/thinkpad_acpi.c
> +++ b/drivers/misc/thinkpad_acpi.c
> @@ -1689,7 +1689,7 @@ static ssize_t hotkey_wakeup_reason_show(struct device *dev,
>  static struct device_attribute dev_attr_hotkey_wakeup_reason =
>  	__ATTR(wakeup_reason, S_IRUGO, hotkey_wakeup_reason_show, NULL);
>  
> -void hotkey_wakeup_reason_notify_change(void)
> +static void hotkey_wakeup_reason_notify_change(void)
>  {
>  	if (tp_features.hotkey_mask)
>  		sysfs_notify(&tpacpi_pdev->dev.kobj, NULL,
> @@ -1708,7 +1708,7 @@ static struct device_attribute dev_attr_hotkey_wakeup_hotunplug_complete =
>  	__ATTR(wakeup_hotunplug_complete, S_IRUGO,
>  	       hotkey_wakeup_hotunplug_complete_show, NULL);
>  
> -void hotkey_wakeup_hotunplug_complete_notify_change(void)
> +static void hotkey_wakeup_hotunplug_complete_notify_change(void)
>  {
>  	if (tp_features.hotkey_mask)
>  		sysfs_notify(&tpacpi_pdev->dev.kobj, NULL,
> 

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

---

That said, I have no idea what toshiba-acpi has to do with the above patch
;-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
