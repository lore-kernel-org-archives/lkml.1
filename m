Return-Path: <linux-kernel-owner+w=401wt.eu-S1764685AbZAWBd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764685AbZAWBd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763014AbZAWBb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:31:26 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14036 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764036AbZAWBbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:31:24 -0500
Date: Fri, 23 Jan 2009 02:31:22 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Florian Fainelli <florian@openwrt.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 24/46] r6040: bump release number to 0.19
In-Reply-To: <20090123011219.GY19756@kroah.com>
Message-ID: <alpine.LNX.2.00.0901230225430.12187@swampdragon.chaosbits.net>
References: <20090123010651.683741823@mini.kroah.org> <20090123011219.GY19756@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009, Greg KH wrote:

> 2.6.28-stable review patch.  If anyone has any objections, please let us know.
> 

It's simple enough, sure, but it doesn't really conform to the guidelines 
set out for -stable patches in Documentation/stable_kernel_rules.txt : 

...
 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).
...
 - It cannot contain any "trivial" fixes in it (spelling changes,
   whitespace cleanups, etc).
...

I'm trying to come up with some real problem this fixes and a reason why 
we want it in -stable, but I cannot...


> 
> From: Florian Fainelli <florian@openwrt.org>
> 
> [ Upstream commit: 4707470ae7441733822efcd680b0ef3971921c4d ]
> 
> This patch bumps the release number of the driver.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/net/r6040.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/net/r6040.c
> +++ b/drivers/net/r6040.c
> @@ -49,8 +49,8 @@
>  #include <asm/processor.h>
>  
>  #define DRV_NAME	"r6040"
> -#define DRV_VERSION	"0.18"
> -#define DRV_RELDATE	"13Jul2008"
> +#define DRV_VERSION	"0.19"
> +#define DRV_RELDATE	"18Dec2008"
>  
>  /* PHY CHIP Address */
>  #define PHY1_ADDR	1	/* For MAC1 */
> 

-- 
Jesper Juhl <jj@chaosbits.net>        http://personal.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

