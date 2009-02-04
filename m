Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZBDIjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZBDIjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZBDIji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:39:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:38521 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbZBDIjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:39:37 -0500
Subject: Re: [GIT PULL -tip] fix 22 make headers_check - 200901
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, mingo@elte.hu, x86@kernel.org,
       sam@ravnborg.org, hpa@zytor.com, jirislaby@gmail.com, gregkh@suse.de,
       davem@davemloft.net, xyzzy@speakeasy.org, arnd@arndb.de,
       mchehab@infradead.org, jens.axboe@oracle.com,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <49894E24.2000908@redhat.com>
References: <20090204064307.GA18415@gondor.apana.org.au>
	 <1233734645.3198.2.camel@localhost.localdomain>
	 <49894E24.2000908@redhat.com>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 14:07:55 +0530
Message-Id: <1233736675.3198.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 10:13 +0200, Avi Kivity wrote:
> Jaswinder Singh Rajput wrote:
> > On Wed, 2009-02-04 at 17:43 +1100, Herbert Xu wrote:
> >   
> >> Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> >>     
> >>> diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
> >>> index b95162a..d2e3bf3 100644
> >>> --- a/arch/x86/include/asm/kvm.h
> >>> +++ b/arch/x86/include/asm/kvm.h
> >>> @@ -6,7 +6,7 @@
> >>>  *
> >>>  */
> >>>
> >>> -#include <asm/types.h>
> >>> +#include <linux/types.h>
> >>> #include <linux/ioctl.h>
> >>>       
> >> Awesome, you've just broken the userspace build of kvm as the
> >> file linux/types.h conflicts with sys/types.h.
> >>
> >>     
> >
> > What I did is absolutely right.
> >
> >   
> 
> It was, though I'd have been happy to know about it in advance (maybe 
> you did notify me; I was on vacation and haven't cleared the backlog yet).
> 

Welcome back :-)

> > If there is any conflict then we need to solve it in better way.
> >
> > Can you please share what is the conflict and what you are expecting and
> > what you are getting.
> >   
> 
> I've already fixed kvm-userspace.git.
> 

Thanks,

--
JSR

