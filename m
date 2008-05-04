Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYEDQvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYEDQvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 12:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbYEDQvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 12:51:04 -0400
Received: from vigor.karmaclothing.net ([217.169.26.28]:56466 "EHLO
	dl5rb.ham-radio-op.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750811AbYEDQvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 12:51:03 -0400
Date: Sun, 4 May 2008 17:50:37 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] MIPS: ELF handling - use SELFMAG instead of
	numeric constant
Message-ID: <20080504165037.GA30417@linux-mips.org>
References: <20080503101800.417039810@gmail.com>> <481c3f59.0407560a.2d49.ffffbf04@mx.google.com> <20080503103558.GB6844@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503103558.GB6844@cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 02:35:58PM +0400, Cyrill Gorcunov wrote:
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> Date: Sat, 3 May 2008 14:35:58 +0400
> To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
> 	ralf@linux-mips.org, linux-kernel@vger.kernel.org
> Subject: Re: [patch 4/4] MIPS: ELF handling - use SELFMAG instead of
> 	numeric constant
> Content-Type: text/plain; charset=us-ascii
> 
> [Cyrill Gorcunov - Sat, May 03, 2008 at 02:18:04PM +0400]
> | Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> | ---
> | 
> | Index: linux-2.6.git/arch/mips/kernel/vpe.c
> | ===================================================================
> | --- linux-2.6.git.orig/arch/mips/kernel/vpe.c	2008-04-15 23:01:26.000000000 +0400
> | +++ linux-2.6.git/arch/mips/kernel/vpe.c	2008-05-02 21:40:57.000000000 +0400
> | @@ -840,7 +840,7 @@ static int vpe_elfload(struct vpe * v)
> |  
> |  	/* Sanity checks against insmoding binaries or wrong arch,
> |  	   weird elf version */
> | -	if (memcmp(hdr->e_ident, ELFMAG, 4) != 0
> | +	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
> |  	    || (hdr->e_type != ET_REL && hdr->e_type != ET_EXEC)
> |  	    || !elf_check_arch(hdr)
> |  	    || hdr->e_shentsize != sizeof(*sechdrs)) {
> | 
> | -- 
> | 
> oops, MIPS was not refreshed by whole. This is a fix.
> ---
> 
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> Subject: MIPS: ELF handling - use SELFMAG instead of numeric constant
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Applied.  Thanks!

  Ralf
