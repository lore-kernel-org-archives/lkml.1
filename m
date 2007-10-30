Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbXJ3HPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbXJ3HPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 03:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbXJ3HPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 03:15:19 -0400
Received: from koto.vergenet.net ([210.128.90.7]:32793 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbXJ3HPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 03:15:17 -0400
Date: Tue, 30 Oct 2007 16:15:13 +0900
From: Simon Horman <horms@verge.net.au>
To: Luming Yu <luming.yu@gmail.com>
Cc: linux-ia64@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix typo in per_cpu_offset
Message-ID: <20071030071513.GE5361@verge.net.au>
References: <3877989d0710230015x1640388aod98cae2fa3fc82c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3877989d0710230015x1640388aod98cae2fa3fc82c2@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 03:15:55PM +0800, Luming Yu wrote:
> Hello list,
> 
> there is a typo in the definition of per_cpu_offset because, for ia64,
> the __per_cpu_offset is an array.
> 
>  extern unsigned long __per_cpu_offset[NR_CPUS];
> -#define per_cpu_offset(x) (__per_cpu_offset(x))
> +#define per_cpu_offset(x) (__per_cpu_offset[x])
> 
> Thanks,
> Luming
> 
> Signed-off-by: Yu Luming <luming.yu@intel.com>

This looks correct to me, and gcc seems to agree too.

Though curiuously with my config nothing uses per_cpu_offset()
(I added a bogus call to produce an error.) Is it actually
used on ia64?

Acked-by: Simon Horman <horms@verge.net.au>

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

