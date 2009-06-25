Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbZFYL5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbZFYL5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZFYL4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:56:55 -0400
Received: from ozlabs.org ([203.10.76.45]:34423 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZFYL4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:56:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paul Menage <menage@google.com>
Subject: Re: [PATCH] UML: Fix some apparent bitrot in mmu_context.h
Date: Thu, 25 Jun 2009 21:26:54 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
References: <20090625071956.20800.4589.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090625071956.20800.4589.stgit@menage.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906252126.54611.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 04:49:56 pm Paul Menage wrote:
> UML: Fix some apparent bitrot in mmu_context.h
>
> - cpumask_clear() -> cpumask_clear_cpu()
>
> Signed-off-by: Paul Menage <menage@google.com>
>
> --
>
> Fixes the following compile errors:
>
> arch/um/include/asm/mmu_context.h: In function 'switch_mm':
> arch/um/include/asm/mmu_context.h:38: warning: passing argument 1 of
> 'cpumask_clear' makes pointer from integer without a cast
> arch/um/include/asm/mmu_context.h:38: error: too many arguments to function
> 'cpumask_clear'

Thanks, that was a bogosity in my patch (not in mainline, may not be now merge 
window closed).

I've fixed it now.

Thanks!
Rusty.
