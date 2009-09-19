Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbZISIgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbZISIgB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 04:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZISIgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 04:36:00 -0400
Received: from [195.41.46.236] ([195.41.46.236]:43405 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbZISIf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 04:35:59 -0400
Date: Sat, 19 Sep 2009 10:35:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] Linker script cleanup patches for m32r
Message-ID: <20090919083555.GA25840@merkur.ravnborg.org>
References: <1253305969-6948-1-git-send-email-tabbott@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253305969-6948-1-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 04:32:43PM -0400, Tim Abbott wrote:
> This is an updated version of the patch series I sent on September 6
> cleaning up the m32r architecture's linker scripts.  It differs from V1
> in that I moved spi_stack_top and spu_stack_top to .init.data at
> Hirokazu Takata's request.
> 
> This cross-architecture linker script cleanup project is in
> preparation for adding support for building the kernel with
> -ffunction-sections -fdata-sections, which is a prerequisite for
> Ksplice.
> 
> 	-Tim Abbott
> 
> Tim Abbott (6):
>   m32r: make PAGE_SIZE available to assembly.
>   m32r: Define THREAD_SIZE only once.
>   m32r: Move GET_THREAD_INFO definition out of asm/thread_info.h.
>   m32r: Remove unused .altinstructions and .exit.* code from linker
>     script.
>   m32r: Move the spi_stack_top and spu_stack_top into .init.data
>     section.
>   m32r: Cleanup linker script using new linker script macros.

Looked through all of these - looks good.
I like how you take the time to do the additional cleanups
that is possible.
Next step would be to introduce the 'normal' style in the linker
script but that can come later.

Acked-by: Sam Ravnborg <sam@ravnborg.org>

For all 6 patches.

	Sam
