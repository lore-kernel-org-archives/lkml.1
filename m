Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbYKFTPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbYKFTPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYKFTP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:15:29 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:54934 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYKFTP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:15:28 -0500
Date: Thu, 6 Nov 2008 13:15:07 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: next-20081106: undefined reference to `__per_cpu_start'
In-Reply-To: <20081106183939.GA26925@x200.localdomain>
Message-ID: <Pine.LNX.4.64.0811061310350.6009@quilx.com>
References: <20081106173645.e7e79071.sfr@canb.auug.org.au>
 <20081106183939.GA26925@x200.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Alexey Dobriyan wrote:

> On blackfin-BF526-EZBRD and other blackfins:
>
>   LD      .tmp_vmlinux1
> mm/built-in.o: In function `cpu_alloc_init':
> (.init.text+0x1486): undefined reference to `__per_cpu_start'
> mm/built-in.o: In function `cpu_alloc_init':
> (.init.text+0x148c): undefined reference to `__per_cpu_start'
> mm/built-in.o: In function `cpu_alloc_init':
> (.init.text+0x1492): undefined reference to `__per_cpu_end'
> mm/built-in.o: In function `cpu_alloc_init':
> (.init.text+0x1496): undefined reference to `__per_cpu_end'

Any contigencies for __per_cpu_start/end in your blackfin vmlinux.lds.h?
That is where these symbols are defined

Or did you use generic percpu support and set
CONFIG_HAVE_ZERO_BASED_PER_CPU?
