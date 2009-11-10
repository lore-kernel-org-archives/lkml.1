Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbZKJWXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbZKJWXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757875AbZKJWXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:23:11 -0500
Received: from mbox2.netikka.net ([213.250.81.203]:44121 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848AbZKJWXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:23:08 -0500
Message-ID: <4AF9E7D4.9080309@mandriva.org>
Date: Wed, 11 Nov 2009 00:23:16 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: stable@kernel.org
Subject: Re: x86: Remove STACKPROTECTOR_ALL
References: <200911021859.nA2Ix4cB023712@hera.kernel.org>
In-Reply-To: <200911021859.nA2Ix4cB023712@hera.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this one should go to 2.6.31.x too ...

> Gitweb:     http://git.kernel.org/linus/14a3f40aafacde1dfd6912327ae14df4baf10304
> Commit:     14a3f40aafacde1dfd6912327ae14df4baf10304
> Parent:     02dd0a0613e0d84c7dd8315e3fe6204d005b7c79
> Author:     Arjan van de Ven <arjan@infradead.org>
> AuthorDate: Fri Oct 23 07:31:01 2009 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri Oct 23 16:35:23 2009 +0200
> 
>     x86: Remove STACKPROTECTOR_ALL
>     
>     STACKPROTECTOR_ALL has a really high overhead (runtime and stack
>     footprint) and is not really worth it protection wise (the
>     normal STACKPROTECTOR is in effect for all functions with
>     buffers already), so lets just remove the option entirely.
>     
>     Reported-by: Dave Jones <davej@redhat.com>
>     Reported-by: Chuck Ebbert <cebbert@redhat.com>
>     Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>     Cc: Eric Sandeen <sandeen@redhat.com>
>     LKML-Reference: <20091023073101.3dce4ebb@infradead.org>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/Kconfig  |    4 ----
>  arch/x86/Makefile |    1 -
>  2 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 07e0114..72ace95 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1443,12 +1443,8 @@ config SECCOMP
>  
>  	  If unsure, say Y. Only embedded should say N here.
>  
> -config CC_STACKPROTECTOR_ALL
> -	bool

