Return-Path: <linux-kernel-owner+w=401wt.eu-S965099AbXBLSAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965099AbXBLSAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965146AbXBLSAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:00:00 -0500
Received: from lazybastard.de ([212.112.238.170]:38204 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965140AbXBLR74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 12:59:56 -0500
Date: Mon, 12 Feb 2007 17:35:23 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86 for review III] [10/29] i386: don't include bugs.h
Message-ID: <20070212173523.GB2112@lazybastard.org>
References: <20070212551.664370000@suse.de> <20070212165130.450D413FCB@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070212165130.450D413FCB@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 February 2007 17:51:30 +0100, Andi Kleen wrote:
> 
> From: Andrew Morton <akpm@osdl.org>
> 
> That stupid non-inlined-static function in bugs.h causes:
> 
> include/asm/bugs.h:186: warning: 'check_bugs' defined but not used
> 
> But fortunately the include isn't needed.
> 
> Cc: Andi Kleen <ak@muc.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
> 
>  arch/i386/kernel/alternative.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: linux/arch/i386/kernel/alternative.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/alternative.c
> +++ linux/arch/i386/kernel/alternative.c
> @@ -4,7 +4,6 @@
>  #include <linux/list.h>
>  #include <asm/alternative.h>
>  #include <asm/sections.h>
> -#include <asm/bugs.h>
>  
>  static int no_replacement    = 0;
>  static int smp_alt_once      = 0;

Didn't your patchset also include a near-identical patch from Adrian
Bunk (with - and + exchanged)?

Jörn

-- 
Courage is not the absence of fear, but rather the judgement that
something else is more important than fear.
-- Ambrose Redmoon
