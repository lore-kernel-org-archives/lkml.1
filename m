Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbZBDIG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbZBDIG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZBDIGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:06:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:45598 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbZBDIGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:06:18 -0500
Subject: Re: [GIT PULL -tip] fix 22 make headers_check - 200901
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: mingo@elte.hu, x86@kernel.org, sam@ravnborg.org, hpa@zytor.com,
       jirislaby@gmail.com, gregkh@suse.de, davem@davemloft.net,
       xyzzy@speakeasy.org, arnd@arndb.de, mchehab@infradead.org,
       jens.axboe@oracle.com, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>
In-Reply-To: <20090204064307.GA18415@gondor.apana.org.au>
References: <20090204064307.GA18415@gondor.apana.org.au>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 13:34:04 +0530
Message-Id: <1233734645.3198.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 17:43 +1100, Herbert Xu wrote:
> Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> >
> > diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
> > index b95162a..d2e3bf3 100644
> > --- a/arch/x86/include/asm/kvm.h
> > +++ b/arch/x86/include/asm/kvm.h
> > @@ -6,7 +6,7 @@
> >  *
> >  */
> > 
> > -#include <asm/types.h>
> > +#include <linux/types.h>
> > #include <linux/ioctl.h>
> 
> Awesome, you've just broken the userspace build of kvm as the
> file linux/types.h conflicts with sys/types.h.
> 

What I did is absolutely right.

If there is any conflict then we need to solve it in better way.

Can you please share what is the conflict and what you are expecting and
what you are getting.

Thanks,
--
JSR

