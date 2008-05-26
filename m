Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbYEZWoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbYEZWoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 18:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbYEZWoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 18:44:13 -0400
Received: from vigor.karmaclothing.net ([217.169.26.28]:50863 "EHLO
	vigor.karmaclothing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbYEZWoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 18:44:12 -0400
Date: Mon, 26 May 2008 23:43:42 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Adrian Bunk <adrian.bunk@movial.fi>
Cc: Chris Dearman <chris@mips.com>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] MIPS SEAD compile fix
Message-ID: <20080526224342.GA28360@linux-mips.org>
References: <20080525180316.GF1791@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080525180316.GF1791@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 09:03:16PM +0300, Adrian Bunk wrote:

> This patch fixes the following compile error caused by
> commit 39b8d5254246ac56342b72f812255c8f7a74dca9
> ([MIPS] Add support for MIPS CMP platform.):
> 
> <--  snip  -->
> 
> ...
>   CC      arch/mips/mips-boards/generic/time.o
> cc1: warnings being treated as errors
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/mips-boards/generic/time.c:63: error: 'ledbitmask' defined but not used
> make[2]: *** [arch/mips/mips-boards/generic/time.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> 
> ---
> a6622e47dd128da338d6dbae457ec1b043604814 diff --git a/arch/mips/mips-boards/generic/time.c b/arch/mips/mips-boards/generic/time.c
> index 008fd82..df23558 100644
> --- a/arch/mips/mips-boards/generic/time.c
> +++ b/arch/mips/mips-boards/generic/time.c

[...]

> +#if defined(CONFIG_MIPS_MALTA) || defined(CONFIG_MIPS_ATLAS)

Generic code thanks to #ifdef ;-)  Not really the way to go.  I just blew
away the original offending change.

  Ralf
