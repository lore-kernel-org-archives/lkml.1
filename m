Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbYCXQ4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbYCXQ4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYCXQ4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:56:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbYCXQ4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:56:41 -0400
Subject: Re: [PATCH 3/6] compcache: TLSF Allocator interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: nitingupta910@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <200803242034.24264.nitingupta910@gmail.com>
References: <200803242034.24264.nitingupta910@gmail.com>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 17:56:17 +0100
Message-Id: <1206377777.6437.123.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-24 at 20:34 +0530, Nitin Gupta wrote:
> Two Level Segregate Fit (TLSF) Allocator is used to allocate memory for
> variable size compressed pages. Its fast and gives low fragmentation.
> Following links give details on this allocator:
>  - http://rtportal.upv.es/rtmalloc/files/tlsf_paper_spe_2007.pdf
>  - http://code.google.com/p/compcache/wiki/TLSFAllocator
> 
> This kernel port of TLSF (v2.3.2) introduces several changes but underlying
> algorithm remains the same.
> 
> Changelog TLSF v2.3.2 vs this kernel port
>  - Pool now dynamically expands/shrinks.
>    It is collection of contiguous memory regions.
>  - Changes to pool create interface as a result of above change.
>  - Collect and export stats (/proc/tlsfinfo)
>  - Cleanups: kernel coding style, added comments, macros -> static inline, etc.

Can you explain why you need this allocator, why don't the current
kernel allocators work for you?




