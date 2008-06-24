Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYFXELw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYFXELw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 00:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYFXELn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 00:11:43 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:42339 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750708AbYFXELm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 00:11:42 -0400
Date: Tue, 24 Jun 2008 13:08:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk, cooloney@kernel.org, dev-etrax@axis.com,
       dhowells@redhat.com, gerg@uclinux.org, yasutake.koichi@jp.panasonic.com,
       linux-parisc@vger.kernel.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-sh@vger.kernel.org, chris@zankel.net, linux-mips@linux-mips.org,
       ysato@users.sourceforge.jp, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm/ptrace.h userspace headers cleanup
Message-ID: <20080624040844.GE22526@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, Roland McGrath <roland@redhat.com>,
	linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk,
	cooloney@kernel.org, dev-etrax@axis.com, dhowells@redhat.com,
	gerg@uclinux.org, yasutake.koichi@jp.panasonic.com,
	linux-parisc@vger.kernel.org, paulus@samba.org,
	linuxppc-dev@ozlabs.org, linux-sh@vger.kernel.org, chris@zankel.net,
	linux-mips@linux-mips.org, ysato@users.sourceforge.jp,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080623174809.GE4756@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623174809.GE4756@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 08:48:09PM +0300, Adrian Bunk wrote:
> This patch contains the following cleanups for the asm/ptrace.h 
> userspace headers:
> - include/asm-generic/Kbuild.asm already lists ptrace.h, remove
>   the superfluous listings in the Kbuild files of the following
>   architectures:
>   - cris
>   - frv
>   - powerpc
>   - x86
> - don't expose function prototypes and macros to userspace:
>   - arm
>   - blackfin
>   - cris
>   - mn10300
>   - parisc
> - remove #ifdef CONFIG_'s around #define's:
>   - blackfin
>   - m68knommu
> - sh: AFAIK __SH5__ should work in both kernel and userspace,
>       no need to leak CONFIG_SUPERH64 to userspace

Yes, that's fine. We've generally avoided relying entirely on the gcc
builtin definitions due to the rampant stupidity surrounding
__SH4_NOFPU__, but it is true that __SH5__ is always defined at least.

Acked-by: Paul Mundt <lethal@linux-sh.org>
