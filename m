Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZFWMox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZFWMox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZFWMop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:44:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:2352 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZFWMop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:44:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SirpD1ZKXvvqUD5ZIeVVNvV/X2o1HQXBxmhTce/vppnIZuCZTQ/1UUKns0FVQgJ84H
         S+jiF0wu4fq2x1nVr6U+3F8s6t/9mlpAOKT5EfhmFshnqqLCugjXbPCXLJi2bZEgBRdr
         YxYVZSR/lVK52fAjt68wkpVdH7IAxaJKNU93k=
Date: Tue, 23 Jun 2009 20:43:57 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] printk boot_delay: use loops_per_msec instead of
	printk_delay_msec
Message-ID: <20090623124357.GB12135@darkstar>
References: <a8e1da0906160202r7124b8a7x29ace04cd910df52@mail.gmail.com> <20090622225553.8aa1dfb7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622225553.8aa1dfb7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 10:55:53PM -0700, Andrew Morton wrote:
> On Tue, 16 Jun 2009 17:02:24 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
> 
> > Sorry, should post this firstly because the previous printk_delay
> > patch depends on this,
> > please review, thanks.
> > --
> > 
> > Use loops_per_msec instead of printk_delay_msec for boot printk delay.
> > 
> 
> The changelog is poor, because it fails to describe _why_ this change
> is being made.  I rewrote it to
> 
>   Rename `printk_delay_msec' to `loops_per_msec', because the patch
>   "printk: add printk_delay to make messages readable for some
>   scenarios" wishes to more appropriately use the `printk_delay_msec'
>   identifier.

Thanks for your improval.

> 
> > 
> > --- linux-2.6.orig/kernel/printk.c	2009-06-15 10:53:10.000000000 +0800
> > +++ linux-2.6/kernel/printk.c	2009-06-15 13:17:13.000000000 +0800
> > @@ -198,12 +198,11 @@ __setup("log_buf_len=", log_buf_len_setu
> >  #ifdef CONFIG_BOOT_PRINTK_DELAY
> > 
> >  static unsigned int boot_delay; /* msecs delay after each printk
> > during bootup */
> > -static unsigned long long printk_delay_msec; /* per msec, based on
> > boot_delay */
> 
> Your email client is wordwrapping the patches.


Thanks, I moved from mutt to web gmail + firefox 'view source with' addon, looks like I should think about using mutt again.
