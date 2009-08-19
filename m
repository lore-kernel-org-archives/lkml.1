Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZHSNr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZHSNr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZHSNr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:47:57 -0400
Received: from us.einfochips.com ([74.54.47.34]:55948 "EHLO us.einfochips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbZHSNr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:47:57 -0400
Message-ID: <4A8C02E9.2090701@einfochips.com>
Date: Wed, 19 Aug 2009 19:19:29 +0530
From: Dhaval Vasa <dhaval.vasa@einfochips.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
CC: nico@cam.org, linux-kernel@vger.kernel.org, rabeeh@marvell.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH v2] [ARM] Kirkwood: Marvell OpenRD-Base board support
 added to v2.6.31-rc5
References: <1249906054-572-1-git-send-email-dhaval.vasa@einfochips.com> <20090819151814.7167bad0@marrow.netinsight.se>
In-Reply-To: <20090819151814.7167bad0@marrow.netinsight.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Kagstrom wrote:
> Hi Dhaval!
> 
> On Mon, 10 Aug 2009 17:37:34 +0530
> Dhaval Vasa <dhaval.vasa@einfochips.com> wrote:
> 
>> reference:
>> http://open-rd.org
>> http://code.google.com/p/openrd
>>
>> This patch is tested for:
>> 1. Boot from DRAM/NAND flash
>> 2. NAND read/write/erase
>> 3. GbE0
>> 4. USB read/write
>>
>> FIXME:
>> 1. SD/UART1 selection
>> 2. MPP configuration (currently, default)
>> 3. PEX
>>
>> Signed-off-by: Dhaval Vasa <dhaval.vasa@einfochips.com>
> 
> Tested-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
> 
>> +static unsigned int openrd_base_mpp_config[] __initdata = {
>> +	MPP29_GPIO,	
>                    ^^^^^
> There is trailing whitespace on this line
> 

Nicolas has already applied this patch on his orion tree; it would be 
worth generating separate one for whitespace ?  Suggest.

> Also, I'd suggest merging "[PATCH v2] Kirkwood: Initialise SATA for
> OpenRD-Base" into this one and resubmit it.

Nicolas has already applied this patch on his orion tree.  Should I 
re-submit now ?

> 
> In my patch, I also called kirkwood_i2c_init (see below), which at
> least make the I2C bus appear (not that I've tested it very much).
> 
> // Simon
> 
> diff --git a/arch/arm/mach-kirkwood/openrd_base-setup.c b/arch/arm/mach-kirkwood/openrd_base-setup.c
> index f9a2166..dc0a2fe 100644
> --- a/arch/arm/mach-kirkwood/openrd_base-setup.c
> +++ b/arch/arm/mach-kirkwood/openrd_base-setup.c
> @@ -71,6 +71,8 @@ static void __init openrd_base_init(void)
>         kirkwood_ge00_init(&openrd_base_ge00_data);
>         kirkwood_sata_init(&openrd_base_sata_data);
>         kirkwood_sdio_init(&openrd_base_mvsdio_data);
> +
> +       kirkwood_i2c_init();
>  }
>  
>  MACHINE_START(OPENRD_BASE, "Marvell OpenRD Base Board")
> 
> 

Can you point me to your patch ?

- Dhaval
-- 
_____________________________________________________________________
Disclaimer: This e-mail message and all attachments transmitted with it
are intended solely for the use of the addressee and may contain legally
privileged and confidential information. If the reader of this message
is not the intended recipient, or an employee or agent responsible for
delivering this message to the intended recipient, you are hereby
notified that any dissemination, distribution, copying, or other use of
this message or its attachments is strictly prohibited. If you have
received this message in error, please notify the sender immediately by
replying to this message and please delete it from your computer. Any
views expressed in this message are those of the individual sender
unless otherwise stated.Company has taken enough precautions to prevent
the spread of viruses. However the company accepts no liability for any
damage caused by any virus transmitted by this email.
_____________________________________________________________________
 
