Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbXLCINU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbXLCINU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 03:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXLCINJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 03:13:09 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:59464 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbXLCINI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 03:13:08 -0500
Message-ID: <4753BA8A.2070404@in.ibm.com>
Date: Mon, 03 Dec 2007 13:42:58 +0530
From: Srinivasa Ds <srinivasa@in.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 14/27] powerpc: ptrace generic resume
References: <20071125215507.4B89226F8C5@magilla.localdomain> <20071125220402.4C43C26F8DE@magilla.localdomain>
In-Reply-To: <20071125220402.4C43C26F8DE@magilla.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> This removes the handling for PTRACE_CONT et al from the powerpc
> ptrace code, so it uses the new generic code via ptrace_request.
 
   I have tested this patchset on powerpc successfully.

> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  arch/powerpc/kernel/ptrace.c |   46 ------------------------------------------
>  1 files changed, 0 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> index b970d79..8b056d2 100644
> --- a/arch/powerpc/kernel/ptrace.c
> +++ b/arch/powerpc/kernel/ptrace.c
> @@ -445,52 +445,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
>  		break;
>  	}


Thanks
 Srinivasa DS
 Linux Technology Centre
 IBM.

