Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbZB0AvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbZB0AvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbZB0Auw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:50:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:42432 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbZB0Auv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:50:51 -0500
MIME-Version: 1.0
In-Reply-To: <20090222000105.17557.49889.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
	 <20090222000105.17557.49889.stgit@vmbox.hanneseder.net>
Date: Fri, 27 Feb 2009 01:50:48 +0100
Message-ID: <154e089b0902261650y30e12d62u759acd9c711af2e7@mail.gmail.com>
Subject: Re: [PATCH 02/16] x86, numa_32.c: fix sparse warning: Using plain 
	integer as NULL pointer
From: Hannes Eder <hannes@hanneseder.net>
To: Ingo Molnar <mingo@elte.hu>, trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added To: Ingo Molnar <mingo@elte.hu>

On Sun, Feb 22, 2009 at 1:01 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> Fix this sparse warning:
>  arch/x86/mm/numa_32.c:197:24: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  arch/x86/mm/numa_32.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
> index d1f7439..3957cd6 100644
> --- a/arch/x86/mm/numa_32.c
> +++ b/arch/x86/mm/numa_32.c
> @@ -194,7 +194,7 @@ void *alloc_remap(int nid, unsigned long size)
>        size = ALIGN(size, L1_CACHE_BYTES);
>
>        if (!allocation || (allocation + size) >= node_remap_end_vaddr[nid])
> -               return 0;
> +               return NULL;
>
>        node_remap_alloc_vaddr[nid] += size;
>        memset(allocation, 0, size);
>
>
