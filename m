Return-Path: <linux-kernel-owner+w=401wt.eu-S1760209AbYEYUZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbYEYUZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 16:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757949AbYEYUY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 16:24:58 -0400
Received: from www.tglx.de ([62.245.132.106]:41759 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757026AbYEYUY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 16:24:57 -0400
Date: Sun, 25 May 2008 22:24:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sven Wegener <sven.wegener@stealer.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove obsolete LOCK macro from
 include/asm-x86/atomic_64.h
In-Reply-To: <Pine.LNX.4.64.0805252114420.25477@titan.stealer.net>
Message-ID: <alpine.LFD.1.10.0805252223570.3295@apollo.tec.linutronix.de>
References: <Pine.LNX.4.64.0805252114420.25477@titan.stealer.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008, Sven Wegener wrote:

> Commit d167a518 "[PATCH] x86_64: x86_64 version of the smp alternative patch."
> has left the LOCK macro in include/asm-x86_64/atomic.h, which is now
> include/asm-x86/atomic_64.h. Its scope should be local to the file, other
> architectures don't provide it, I couldn't find an in-tree user of it and
> allyesconfig, allmodconfig and allnoconfig build fine without it, so this
> patch
> removes it.
> 
> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>

Applied. Thanks,
	
	tglx

> ---
>  include/asm-x86/atomic_64.h |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/include/asm-x86/atomic_64.h b/include/asm-x86/atomic_64.h
> index 3e0cd7d..fe589c1 100644
> --- a/include/asm-x86/atomic_64.h
> +++ b/include/asm-x86/atomic_64.h
> @@ -11,12 +11,6 @@
>   * resource counting etc..
>   */
> 
> -#ifdef CONFIG_SMP
> -#define LOCK "lock ; "
> -#else
> -#define LOCK ""
> -#endif
> -
>  /*
>   * Make sure gcc doesn't try to be clever and move things around
>   * on us. We need to use _exactly_ the address the user gave us,
> 
