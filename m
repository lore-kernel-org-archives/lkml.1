Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZBDGoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZBDGoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 01:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbZBDGo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 01:44:28 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:38500 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751377AbZBDGo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 01:44:27 -0500
Date: Wed, 4 Feb 2009 17:43:07 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: mingo@elte.hu, x86@kernel.org, sam@ravnborg.org, hpa@zytor.com,
       jirislaby@gmail.com, gregkh@suse.de, davem@davemloft.net,
       xyzzy@speakeasy.org, arnd@arndb.de, mchehab@infradead.org,
       jens.axboe@oracle.com, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [GIT PULL -tip] fix 22 make headers_check - 200901
Message-ID: <20090204064307.GA18415@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232801817.3125.21.camel@localhost.localdomain>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
>
> diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
> index b95162a..d2e3bf3 100644
> --- a/arch/x86/include/asm/kvm.h
> +++ b/arch/x86/include/asm/kvm.h
> @@ -6,7 +6,7 @@
>  *
>  */
> 
> -#include <asm/types.h>
> +#include <linux/types.h>
> #include <linux/ioctl.h>

Awesome, you've just broken the userspace build of kvm as the
file linux/types.h conflicts with sys/types.h.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
