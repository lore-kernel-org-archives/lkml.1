Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYCLVVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYCLVVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYCLVVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:21:40 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:28715 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYCLVVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:21:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uH+ztfwB69/cPv2DlWYolLRu2LydPAq9G2l06mN8KyHih2khRG8l087ljkFxg19b1N2Ld2TK2H+n0w1BX846Qx+6R59N/r5zVA0u6HCEnbTURunPd6vqC4Avto5X2PIHNPh68YD6cNpS3oxZTcEYeVZjbNOo5WIaeoI+J/DdKIU=
Message-ID: <aa79d98a0803121421gda8354akaa36cee2f225a2b4@mail.gmail.com>
Date: Thu, 13 Mar 2008 00:21:37 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: parocessor.h - use PAGE_SIZE instead of numeric constant
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47D846CE.1020005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080312201405.GA9591@cvg> <47D846CE.1020005@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yep, it wold be more elegant, i'll fix it tomorrow. (sorry for
top-posting, i'm not on my local laptop now)

On 3/13/08, H. Peter Anvin <hpa@zytor.com> wrote:
> Cyrill Gorcunov wrote:
> > This patch replaces numeric constant with an appropriate macro
> >
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> >
> > ---
> >
> > Index: linux-2.6.git/include/asm-x86/processor.h
> > ===================================================================
> > --- linux-2.6.git.orig/include/asm-x86/processor.h	2008-02-20
> 19:14:57.000000000 +0300
> > +++ linux-2.6.git/include/asm-x86/processor.h	2008-03-12
> 23:10:02.000000000 +0300
> > @@ -786,7 +786,7 @@ extern unsigned long thread_saved_pc(str
> >  /*
> >   * User space process size. 47bits minus one guard page.
> >   */
> > -#define TASK_SIZE64	(0x800000000000UL - 4096)
> > +#define TASK_SIZE64	(0x800000000000UL - PAGE_SIZE)
> >
> >  /* This decides where the kernel will search for a free chunk of vm
> >   * space during mmap's.
>
> Although I'd personally prefer ((1UL << 47) - PAGE_SIZE)
>
> 	-hpa
>
