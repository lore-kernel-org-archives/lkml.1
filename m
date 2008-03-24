Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbYCXUoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbYCXUoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYCXUoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:44:13 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:5880 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYCXUoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:44:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=IYAUK2p5mQxKEF9Ufz6jC9Uqf7+Bxdvn7a7JV3AAaOaiPG/uxZ7iaS5oC9l7jnAt5diJll8jJIURo7+C9ASCKzQZ7bxSGr0ZUSh8z1mym5GhGtvqt4VPoI8izJH8eXnKuE25qq4TCLrRmAnhwKWXKpyRj+KHzwxIP80F54tmcVI=
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: nitingupta910@gmail.com
To: "Will Newton" <will.newton@gmail.com>
Subject: Re: [PATCH 2/6] compcache: block device - internal defs
Date: Tue, 25 Mar 2008 02:09:27 +0530
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <200803242033.30782.nitingupta910@gmail.com> <4cefeab80803241050y1ee7c22fi73234f24e65f958a@mail.gmail.com> <87a5b0800803241336u547e0f39j277a8857ce674403@mail.gmail.com>
In-Reply-To: <87a5b0800803241336u547e0f39j277a8857ce674403@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803250209.28332.nitingupta910@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 March 2008 02:06:02 am Will Newton wrote:
> On Mon, Mar 24, 2008 at 5:50 PM, Nitin Gupta <nitingupta910@gmail.com> wrote:
> >  >  >  +
> >  >  >  +/* Create /proc/compcache? */
> >  >  >  +/* If STATS is disabled, this will give minimal compcache info */
> >  >  >  +#define CONFIG_COMPCACHE_PROC
> >  >  >  +
> >  >  >  +#if DEBUG
> >  >  >  +#define CC_DEBUG(fmt,arg...) \
> >  >  >  +       printk(KERN_DEBUG C fmt,##arg)
> >  >  >  +#else
> >  >  >  +#define CC_DEBUG(fmt,arg...) NOP
> >  >  >  +#endif
> >  >
> >  >  Have you thought about using pr_debug() for this? It looks like it
> >  >  would simplify this file at the cost of a little flexibility.
> >  >
> >
> >  I want to enable/disable this debugging based on DEBUG_COMPCACHE flag.
> >  Thats why I added these macros. I will do 'printk(KERN_DEBUG' ->
> >  pr_debug
> 
> The definition of pr_debug (kernel.h) is already surrounded by #ifdef
> DEBUG so it may give you the same behaviour as the CC_DEBUG macro.
> 

Yes, I missed this point. But still, I want to have two levels of debugging. I can probably use pr_debug() for "normal" debug and CC_DEBUG for "verbose" debugging. This looks bit inconsistent, so maybe I should stick which CC_DEBUG/CC_DEBUG2 pair instead?

- Nitin
