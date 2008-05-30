Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYE3D0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYE3D0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 23:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYE3D0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 23:26:34 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:36772 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752104AbYE3D0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 23:26:33 -0400
Date: Fri, 30 May 2008 12:24:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sh/kernel/cpu/irq/intc-sh5.c build fix
Message-ID: <20080530032447.GC13663@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080529220449.GA1763@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529220449.GA1763@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 01:04:49AM +0300, Adrian Bunk wrote:
> This patch fixes the following build error caused by
> commit a1dc4b59fa4af97ae68ee214d4d72bbd7c7ec1dc
> (sh: intc_sh5 depends on cayman board for IRQ priority table.):
> 
> <--  snip  -->
> 
> ...
>   CC      arch/sh/kernel/cpu/irq/intc-sh5.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/kernel/cpu/irq/intc-sh5.c: In function 'plat_irq_setup':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/kernel/cpu/irq/intc-sh5.c:257: error: expected declaration or statement at end of input
> make[4]: *** [arch/sh/kernel/cpu/irq/intc-sh5.o] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Applied, thanks Adrian.
