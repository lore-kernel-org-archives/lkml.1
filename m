Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbZFJSta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbZFJSta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 14:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbZFJStW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 14:49:22 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:52536 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbZFJStW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 14:49:22 -0400
Message-ID: <4A2FFFDA.6010807@free.fr>
Date: Wed, 10 Jun 2009 20:47:54 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081204 Iceape/1.1.14 (Debian-1.1.14-1)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Florian Fainelli <florian@openwrt.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, biblbroks@sezampro.rs
Subject: Re: add bcm47xx watchdog driver
References: <4A282D98.6020004@free.fr> <20090605124813.d7666ed0.akpm@linux-foundation.org> <4A29805D.60205@free.fr> <200906081615.45889.florian@openwrt.org> <20090610171732.GI16090@infomag.iguana.be>
In-Reply-To: <20090610171732.GI16090@infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Wim Van Sebroeck wrote:
> Hi Matthieu, Florian,
> 
>> It works very well on my Netgear WGT634U, thanks !
>>
>> Tested-by: Florian Fainelli <florian@openwrt.org>
> 
> I incorporated the changes of Andrew and did a clean-up here and there to keep checkpatch happy.
> Could you test the attached diff to see that it still works.
> 
> Thanks,
> Wim.
> 

> +
> +#define WDT_DEFAULT_TIME	30	/* seconds */
> +#define WDT_MAX_TIME		255	/* seconds */
Why have changed this from 256 to 255 ?

> +}
> +
> +static int bcm47xx_wdt_notify_sys(struct notifier_block *this,
> +	nsigned long code, void *unused)
        ^^^^
Does this build ?


Matthieu
