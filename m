Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbXLEXMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbXLEXMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 18:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbXLEXMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 18:12:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838AbXLEXM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 18:12:29 -0500
Date: Wed, 5 Dec 2007 15:11:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: miltonm@bga.com, geoffrey.levand@am.sony.com, clameter@sgi.com,
       apw@shadowen.org, linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
Message-Id: <20071205151147.9db4640b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.62.0712051013040.28855@pademelon.sonytel.be>
References: <47537F2E.2070204@am.sony.com>
	<b91f94dd5b35247fecf52090c0b3890f@bga.com>
	<Pine.LNX.4.62.0712051013040.28855@pademelon.sonytel.be>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2007 10:52:48 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> --------------------------------------------------------------------------------
> Subject: sparsemem: sparse_add_one_section() may fail to allocate memory
> 
> sparsemem: sparse_add_one_section() may fail to allocate memory, and must check
> whether the allocation succeeded before proceeding to touch the allocated
> memory.
> 
> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> ---
> FIXME There are still some possible memory leaks in sparse_add_one_section():
>   - usemap is never deallocated
>   - __kfree_section_memmap() is a not yet implemented dummy

I already had

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch
and
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch

queued.  Do they fix the problem, and should they be merged in 2.6.24?
