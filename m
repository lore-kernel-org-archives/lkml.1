Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502Ab0AIA4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0AIA4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274Ab0AIA4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:56:09 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:54715 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0AIA4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:56:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=rQ0cYLxuo/xEEaJ58gufscBWkRii3/ya3w/aCUy7/8G/v3ieo72j8rXLbPPX1mKL34
         6IpLS5GPgDpz1O1Xz66rcsVQ2LDNw/teD3J5hznFOw/GkC43rFO+NizFERvPrj8eaBfF
         QMPyOkLToIyvimTDapVpwkBDdbwzdweQ6ZgFY=
MIME-Version: 1.0
In-Reply-To: <20100108220533.23489.99121.stgit@warthog.procyon.org.uk>
References: <20100108220516.23489.11319.stgit@warthog.procyon.org.uk> 
	<20100108220533.23489.99121.stgit@warthog.procyon.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 8 Jan 2010 19:55:48 -0500
Message-ID: <8bd0f97a1001081655s4ee3d4a7q3ef6a10d211ce6d1@mail.gmail.com>
Subject: Re: [PATCH 4/6] NOMMU: Don't need get_unmapped_area() for NOMMU
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, lethal@linux-sh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 17:05, David Howells wrote:
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
>
> +#ifdef CONFIG_MMU
> +extern void arch_pick_mmap_layout(struct mm_struct *mm);
> +#else
> +extern void arch_pick_mmap_layout(struct mm_struct *mm) {}
> +#endif

static inline instead of extern when !MMU ?
-mike
