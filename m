Return-Path: <linux-kernel-owner+w=401wt.eu-S1763617AbYECRZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763617AbYECRZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761882AbYECRZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:25:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:21755 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761868AbYECRZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:25:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EOJLXJJLi6N4O/53pWtgLhUGWnL4t+DMPTlqBP6VwvrG3UUNZ8ohK3wWESHm8soB0khkI27RoCgcpRZ9XKBCJfri08d/xkfPI3x6jfPyyWkx85Psa04apdDwH9ao9FltgZsALcx0SSq3oFnzi5g1pqjjFNJQK5oTCH68uwi6hrw=
Message-ID: <481C9FFB.3090207@gmail.com>
Date: Sat, 03 May 2008 19:25:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: monstr@seznam.cz
CC: paulus@samba.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 1/2] OF: clean coding style - prom_parse.c
References: <monstr@seznam.cz> <1209827626-8562-1-git-send-email-monstr@seznam.cz> <c382f7ff87d1502c20423742ad738e50a118cf62.1209827449.git.monstr@monstr.eu>
In-Reply-To: <c382f7ff87d1502c20423742ad738e50a118cf62.1209827449.git.monstr@monstr.eu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2008 05:13 PM, monstr@seznam.cz wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/powerpc/kernel/prom_parse.c |   98 ++++++++++++++++++--------------------
>  1 files changed, 46 insertions(+), 52 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/prom_parse.c b/arch/powerpc/kernel/prom_parse.c
> index 90eb3a3..7c6b07c 100644
> --- a/arch/powerpc/kernel/prom_parse.c
> +++ b/arch/powerpc/kernel/prom_parse.c
> @@ -31,21 +25,19 @@ static int __of_address_to_resource(struct device_node *dev,
>  		const u32 *addrp, u64 size, unsigned int flags,
>  		struct resource *r);
>  
> -
>  /* Debug utility */
>  #ifdef DEBUG
>  static void of_dump_addr(const char *s, const u32 *addr, int na)
>  {
> -	printk("%s", s);
> -	while(na--)
> -		printk(" %08x", *(addr++));
> -	printk("\n");
> +	printk(KERN_INFO "%s", s);
> +	while (na--)
> +		printk(KERN_INFO " %08x", *(addr++));
> +	printk(KERN_INFO "\n");

This is wrong you'll get
string <6> XXXXXXXX <6> XXXXXXX ... <6>

