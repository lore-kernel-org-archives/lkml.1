Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZFDOUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZFDOUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZFDOT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:19:57 -0400
Received: from h155.mvista.com ([63.81.120.155]:22385 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753409AbZFDOT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:19:56 -0400
Message-ID: <4A27D85D.6040504@ru.mvista.com>
Date: Thu, 04 Jun 2009 18:21:17 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
Cc: Linux-MIPS <linux-mips@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Takashi Iwai <tiwai@suse.de>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 1/8] add lib/gcd.c
References: <200906041615.10467.florian@openwrt.org>
In-Reply-To: <200906041615.10467.florian@openwrt.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Florian Fainelli wrote:

> This patch adds lib/gcd.c which contains a greatest
> common divider implementation taken from
> sound/core/pcm_timer.c

> Signed-off-by: Florian Fainelli <florian@openwrt.org>

[...]

> diff --git a/lib/gcd.c b/lib/gcd.c
> new file mode 100644
> index 0000000..fbf81a8
> --- /dev/null
> +++ b/lib/gcd.c
> @@ -0,0 +1,20 @@
> +#include <linux/gcd.h>
> +#include <linux/module.h>
> +
> +/* Greatest common divisor */
> +unsigned long gcd(unsigned long a, unsigned long b)
> +{
> +	unsigned long r;
> +
> +	if (a < b) {
> +		r = a;
> +		a = b;
> +	b = r;

    Fix indetnation please.

> +	}
> +	while ((r = a % b) != 0) {
> +		a = b;
> +		b = r;
> +	}
> +	return b;
> +}
> +EXPORT_SYMBOL(gcd);

WBR, Sergei
