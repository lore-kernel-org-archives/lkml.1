Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZKTMmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZKTMmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 07:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZKTMmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 07:42:49 -0500
Received: from mail.atmel.fr ([81.80.104.162]:54500 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753062AbZKTMmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 07:42:49 -0500
Message-ID: <4B068EBF.9020403@atmel.com>
Date: Fri, 20 Nov 2009 13:42:39 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
       Andrew Victor <linux@maxim.org.za>,
       Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [GIT PULL] AT91 Kconfig rework
References: <4B01702B.4080107@atmel.com> <20091119230122.GI22232@n2100.arm.linux.org.uk>
In-Reply-To: <20091119230122.GI22232@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux :
> On Mon, Nov 16, 2009 at 04:30:51PM +0100, Nicolas Ferre wrote:
>> Hi Russell,
>>
>> This is AT91 Kconfig rework for next merge window. After 
>> discussing it on the mailing-list and Ack by Andrew Victor, I 
>> send you this patchset. You can pull it from:
>>
>>   git://github.com/at91linux/linux-2.6-at91.git for-rmk
> 
> FYI:
> 
> $ git pull git://github.com/at91linux/linux-2.6-at91.git for-rmk
> remote: Counting objects: 41, done.
> remote: Compressing objects: 100% (28/28), done.
> remote: Total 30 (delta 26), reused 2 (delta 2)
> Unpacking objects: 100% (30/30), done.
>>From git://github.com/at91linux/linux-2.6-at91
>  * branch            for-rmk    -> FETCH_HEAD
> Auto-merging arch/arm/mach-at91/Kconfig
> CONFLICT (content): Merge conflict in arch/arm/mach-at91/Kconfig
> Recorded preimage for 'arch/arm/mach-at91/Kconfig'
> Automatic merge failed; fix conflicts and then commit the result.
> $ git diff-files -u
> diff --cc arch/arm/mach-at91/Kconfig
> index 2fd8843,3df124e..0000000
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@@ -320,7 -337,7 +337,11 @@@ config MACH_AT91SAM9G20E
>   
>   config MACH_AT91SAM9G20EK_2MMC
>   	bool "Atmel AT91SAM9G20-EK Evaluation Kit with 2 SD/MMC Slots"
> ++<<<<<<< HEAD:arch/arm/mach-at91/Kconfig
>  +	depends on ARCH_AT91SAM9G20
> ++=======
> + 	select HAVE_NAND_ATMEL_BUSWIDTH_16
> ++>>>>>>> 0912e5359f89f303f53fd4874dadab77a4949a8a:arch/arm/mach-at91/Kconfig
>   	help
>   	  Select this if you are using an Atmel AT91SAM9G20-EK Evaluation Kit
>   	  with 2 SD/MMC Slots. This is the case for AT91SAM9G20-EK rev. C and
> @@@ -394,7 -411,7 +415,11 @@@ config MTD_AT91_DATAFLASH_CAR
>   
>   config MTD_NAND_ATMEL_BUSWIDTH_16
>   	bool "Enable 16-bit data bus interface to NAND flash"
> ++<<<<<<< HEAD:arch/arm/mach-at91/Kconfig
>  +	depends on (MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK || MACH_AT91SAM9G20EK || MACH_AT91SAM9G20EK_2MMC || MACH_AT91SAM9G45EKES || MACH_AT91CAP9ADK)
> ++=======
> + 	depends on HAVE_NAND_ATMEL_BUSWIDTH_16
> ++>>>>>>> 0912e5359f89f303f53fd4874dadab77a4949a8a:arch/arm/mach-at91/Kconfig
>   	help
>   	  On AT91SAM926x boards both types of NAND flash can be present
>   	  (8 and 16 bit data bus width).
> 
> What's the resolution?  I think the first is just to include both, but
> the second looks like the first depends needs deleting to leave only the
> second?

Well, in fact the resolution for both is to keep the second line only.

Thanks.

Best regards,
-- 
Nicolas Ferre

