Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbZFEKwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbZFEKwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbZFEKwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 06:52:46 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:40427 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZFEKwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:52:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=llZ3Dwo52nPv/d7qK8G5RuYdxD8bRKwu8JewLN4sWTeuwo4R/JpqxiFQ4OkKN/rQn4
         BNHiXAI/vMzrkG9a2e10OLwdn2M8AVjdcLQj6sxgHpxQB+3whQfczLlF+8d+qVRe6+GC
         yI/jy+bAL7TBGG1pTlfaX0xY/kRmT8EY5L0HU=
Message-ID: <4A28F94A.6040500@tuffmail.co.uk>
Date: Fri, 05 Jun 2009 11:54:02 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: acpi4asus-user@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Corentin Chary <corentincj@iksaif.net>,
       Matthew Garrett <mjg@redhat.com>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH] eeepc-laptop.c: use pr_fmt and pr_<level>
References: <1244197103.3631.40.camel@Joe-Laptop.home>
In-Reply-To: <1244197103.3631.40.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Convert the unusual printk(EEEPC_<level> uses to
> the more standard pr_fmt and pr_<level>(.
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index 353a898..94cacdd 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -16,6 +16,8 @@
>   *  GNU General Public License for more details.
>   */
>  
> +#define pr_fmt(fmt) EEEPC_HOTK_FILE ": " fmt
>
>   

Is EEEPC_HOTK_FILE used anywhere else?  It would be clearer if you were 
able to just use "eeepc: " or whatever and remove the definition of 
EEEPC_HOTK_FILE.

Thanks for the cleanup
Alan

