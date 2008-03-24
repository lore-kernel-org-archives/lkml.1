Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbYCXUgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbYCXUgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYCXUgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:36:04 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:59007 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbYCXUgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:36:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rvC1GooOCl6n0RcSkArqNwqpANv7v/w9y8J9Lb8YB5Brb8jGV5D5slAx2CruK1AeGrKV3ZPX88+voMszovx3v6L3NCW+z96uf/tvPr7lq6fm/hSBZxlE9Gpe55fp/LA/9++JvyNFAMIM1ft4Qz3zvN9QvjOsZRBNqC5JinMlQwU=
Message-ID: <87a5b0800803241336u547e0f39j277a8857ce674403@mail.gmail.com>
Date: Mon, 24 Mar 2008 20:36:02 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Subject: Re: [PATCH 2/6] compcache: block device - internal defs
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <4cefeab80803241050y1ee7c22fi73234f24e65f958a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803242033.30782.nitingupta910@gmail.com>
	 <87a5b0800803240905g705a8ea3p11c415ad37fc3cbb@mail.gmail.com>
	 <4cefeab80803241050y1ee7c22fi73234f24e65f958a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 5:50 PM, Nitin Gupta <nitingupta910@gmail.com> wrote:
>  >  >  +
>  >  >  +/* Create /proc/compcache? */
>  >  >  +/* If STATS is disabled, this will give minimal compcache info */
>  >  >  +#define CONFIG_COMPCACHE_PROC
>  >  >  +
>  >  >  +#if DEBUG
>  >  >  +#define CC_DEBUG(fmt,arg...) \
>  >  >  +       printk(KERN_DEBUG C fmt,##arg)
>  >  >  +#else
>  >  >  +#define CC_DEBUG(fmt,arg...) NOP
>  >  >  +#endif
>  >
>  >  Have you thought about using pr_debug() for this? It looks like it
>  >  would simplify this file at the cost of a little flexibility.
>  >
>
>  I want to enable/disable this debugging based on DEBUG_COMPCACHE flag.
>  Thats why I added these macros. I will do 'printk(KERN_DEBUG' ->
>  pr_debug

The definition of pr_debug (kernel.h) is already surrounded by #ifdef
DEBUG so it may give you the same behaviour as the CC_DEBUG macro.
