Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYH0JlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYH0JlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYH0JlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:41:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:63247 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbYH0JlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WOLwE8uzDmc1r51UoGp14ka8tkj//fo2Y860TiQQ1uF3xFggaypMa99A25fOFpA8ui
         u2YY3Y+nVewrrk4NVgXLxf4BPsyfJWiSajjHU/KNgySNZlf2OK+rXCKlCSnQCoZgbUS7
         tO9re9Jl7FksyliAmVGYjbkeT5uJzrEk0PcTk=
Message-ID: <aec7e5c30808270241x12bac614lc573293ce84d608e@mail.gmail.com>
Date: Wed, 27 Aug 2008 18:41:03 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: [PATCH] VIDEO_SH_MOBILE_CEU should depend on HAS_DMA (was: Re: m68k allmodconfig)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Paul Mundt" <lethal@linux-sh.org>, video4linux-list@redhat.com,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808262035310.7910@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080814195522.ad74990c.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0808262035310.7910@anakin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 4:37 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>        Hi Andrew,
>
> On Thu, 14 Aug 2008, Andrew Morton wrote:
>> ERROR: "dma_alloc_coherent" [drivers/media/video/videobuf-dma-contig.ko] undefined!
>> ERROR: "dma_sync_single_for_cpu" [drivers/media/video/videobuf-dma-contig.ko] undefined!
>> ERROR: "dma_free_coherent" [drivers/media/video/videobuf-dma-contig.ko] undefined!
>
> M68k allmodconfig still selects Sun-3, which sets NO_DMA.
> I guess you're also seeing this on the other NO_DMA platforms (h8300, m32r,
> s390, and PCI-less SPARC)?
>
> Below is a patch.
>
> Shouldn't it also (or instead) depend on SUPERH or some SuperH platform?
> Or is this not done to have more compile-coverage?
>
> Subject: [PATCH] VIDEO_SH_MOBILE_CEU should depend on HAS_DMA
>
> commit 0d3244d6439c8c31d2a29efd587c7aca9042c8aa ("V4L/DVB (8342):
> sh_mobile_ceu_camera: Add SuperH Mobile CEU driver V3") introduced
> VIDEO_SH_MOBILE_CEU, which selects VIDEOBUF_DMA_CONTIG. This circumvents the
> dependency on HAS_DMA of VIDEOBUF_DMA_CONTIG.
>
> Add a dependency on HAS_DMA to VIDEO_SH_MOBILE_CEU to fix this.

Thank you!

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Magnus Damm <damm@igel.co.jp>
