Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbZDKLKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbZDKLKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 07:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZDKLKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 07:10:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56045 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbZDKLKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 07:10:17 -0400
Date: Sat, 11 Apr 2009 08:09:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Marton Balint <cus@fazekas.hu>,
       linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for April 9
Message-ID: <20090411080953.0c22cf4e@pedra.chehab.org>
In-Reply-To: <20090410231158.33b85dc1.akpm@linux-foundation.org>
References: <20090409163305.8c7a0371.sfr@canb.auug.org.au>
	<20090410231158.33b85dc1.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 23:11:58 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 9 Apr 2009 16:33:05 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> 
> It has a link failure with i386 allmodconfig due to missing __divdi3.
> 
> It's due to this statement in drivers/media/video/cx88/cx88-dsp.c's
> int_goertzel():
> 
>         return (u32)(((s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
>                       (s64)coeff*s_prev2*s_prev/32768)/N/N);
> 
> that gem will need to be converted to use div64() or similar, please.

Updated to use do_div().


Cheers,
Mauro
