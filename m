Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab0CJXq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:46:26 -0500
Received: from ozlabs.org ([203.10.76.45]:60281 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757439Ab0CJXqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:46:24 -0500
Date: Thu, 11 Mar 2010 10:46:20 +1100
From: Paul Mackerras <paulus@samba.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 5/6] early_res: seperate common memmap func from e820.c
 to fw_memmap.c
Message-ID: <20100310234620.GA3897@brick.ozlabs.ibm.com>
References: <1268256267-3769-1-git-send-email-yinghai@kernel.org>
 <1268256267-3769-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268256267-3769-6-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 01:24:26PM -0800, Yinghai Lu wrote:

> move it to kernel/fw_memmap.c from arch/x86/kernel/e820.c
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/e820.h |  130 -----
>  arch/x86/kernel/e820.c      | 1142 --------------------------------------------
>  include/linux/bootmem.h     |    2 
>  include/linux/fw_memmap.h   |  114 ++++
>  kernel/Makefile             |    2 
>  kernel/fw_memmap.c          | 1134 +++++++++++++++++++++++++++++++++++++++++++

Yuck.  So you think we should use > 1100 lines of fw_memmap.c code
instead of the 541 lines of lib/lmb.c?  Why exactly would that be
better?

Paul.
