Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbXJWSmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbXJWSmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXJWSm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:42:28 -0400
Received: from brick.kernel.dk ([87.55.233.238]:24553 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbXJWSm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:42:27 -0400
Date: Tue, 23 Oct 2007 20:42:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix breakage after SG cleanups
Message-ID: <20071023184222.GC14671@kernel.dk>
References: <20071023154106.GA29757@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023154106.GA29757@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Ralf Baechle wrote:
> Patches
> 
>    58b053e4ce9d2fc3023645c1b96e537c72aa8d9a
>    45711f1af6eff1a6d010703b4862e0d2b9afd056
>    fa05f1286be25a8ce915c5dd492aea61126b3f33
> 
> convert many files to use the scatter gather helpers without ensuring
> that the necessary headerfile <linux/scatterlist> is included.  This
> happened to work for ia64, powerpc, sparc64 and x86 because they happened
> to drag in that file via their <asm/dma-mapping.h>.  On most of the others
> this probably broke.
> 
> Instead of increasing the header file spider web I choose to include
> <linux/scatterlist.h> directly into the affectes files.

Thanks Ralf, I cut the pieces that are already merged and applied the
rest.

-- 
Jens Axboe

