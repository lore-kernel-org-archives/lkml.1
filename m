Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbXGVB5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbXGVB5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 21:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXGVB5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 21:57:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:40829 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbXGVB5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 21:57:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G20aBcefaogDYzsXpGk64nA0fCQFwjaYQt+neDuqCIY5zpebQ0nxKueO4tY38dH6wInKZp5E9yraMK2+xi16dMCDqKtfooIhsIm/DYff2BUIn3D+BAJ1XBNwrhJna5fnipSM0bpwtRkX1PENgN3TchscY06j42mqGaCRhXtz9Wg=
Message-ID: <625fc13d0707211857l4952cf1wec0d038859512bea@mail.gmail.com>
Date: Sat, 21 Jul 2007 20:57:06 -0500
From: "Josh Boyer" <jwboyer@gmail.com>
To: "Dave Jones" <davej@redhat.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, paulus@samba.org
Subject: Re: fix modular compilation of pmu_battery
In-Reply-To: <20070721184201.GA23306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070721184201.GA23306@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Dave Jones <davej@redhat.com> wrote:
> pmu_battery fails to compile as a module on ppc64.
>
> ERROR: "pmu_batteries" [drivers/power/pmu_battery.ko] undefined!
> ERROR: "pmu_battery_count" [drivers/power/pmu_battery.ko] undefined!
> ERROR: "pmu_power_flags" [drivers/power/pmu_battery.ko] undefined!
>
> Signed-off-by: Dave Jones <davej@redhat.com>
>
> --- linux-2.6.22.noarch/drivers/macintosh/via-pmu.c~    2007-07-20 20:45:27.000000000 -0400
> +++ linux-2.6.22.noarch/drivers/macintosh/via-pmu.c     2007-07-20 20:45:52.000000000 -0400
> @@ -2842,10 +2842,10 @@ EXPORT_SYMBOL(pmu_wait_complete);
>  EXPORT_SYMBOL(pmu_suspend);
>  EXPORT_SYMBOL(pmu_resume);
>  EXPORT_SYMBOL(pmu_unlock);
> -#if defined(CONFIG_PM) && defined(CONFIG_PPC32)
> +#if defined(CONFIG_PM)
>  EXPORT_SYMBOL(pmu_enable_irled);
>  EXPORT_SYMBOL(pmu_battery_count);
>  EXPORT_SYMBOL(pmu_batteries);
>  EXPORT_SYMBOL(pmu_power_flags);
> -#endif /* CONFIG_PM && CONFIG_PPC32 */
> +#endif

Paul has a different fix for this pending on the linuxppc-dev list.

josh
