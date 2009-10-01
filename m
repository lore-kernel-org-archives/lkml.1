Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbZJAT5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbZJAT5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbZJAT5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:57:45 -0400
Received: from mail.perches.com ([173.55.12.10]:1592 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbZJAT5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:57:44 -0400
Subject: Re: [RFC PATCH] kernel.h: Add pr_debug_noopt
From: Joe Perches <joe@perches.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4AC506B2.2040409@caviumnetworks.com>
References: <1254424323.1799.84.camel@Joe-Laptop.home>
	 <4AC506B2.2040409@caviumnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Oct 2009 12:57:47 -0700
Message-Id: <1254427068.1799.88.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 12:44 -0700, David Daney wrote:
> Joe Perches wrote:
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -380,6 +380,8 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
> >          printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
> >  #define pr_info(fmt, ...) \
> >          printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_debug_noopt(fmt, ...) \
> > +	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)

> To me, 'noopt' is too much like 'nop'.

noopt is not ideal.  I'd prefer pr_dbg.

> How about 'mand' or 'ungated' or something similar?

Maybe pr_debug_always which is just 1 letter longer


