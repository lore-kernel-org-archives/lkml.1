Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbZDVVjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbZDVVjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZDVVjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:39:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:53701 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752176AbZDVVja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:39:30 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX19lAvg8r7NldjXWlCu3OBZi4mI42V+aTSSFtXMQcH
	5JDIBpAhvjpZNU
Message-ID: <49EF8E8E.10104@gmx.de>
Date: Wed, 22 Apr 2009 23:39:26 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: coly.li@suse.de, Kyle McMartin <kyle@mcmartin.ca>,
       linux-parisc <linux-parisc@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/7] parisc: add parameter to read_cr16()
References: <49EF6AAE.5000207@suse.de>
In-Reply-To: <49EF6AAE.5000207@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coly Li wrote:
> This patch modifies parameter of au1x_counter1_read() from 'void' to 'struct
> clocksource *cs', which fixes compile warning for incompatible parameter type.
> 
> Signed-off-by: Coly Li <coly.li@suse.de>
> Cc: Helge Deller <deller@gmx.de>

Patch is good.
Thanks!

Acked-by: Helge Deller <deller@gmx.de>


> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/parisc/kernel/time.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
> index d4dd056..d97d07f 100644
> --- a/arch/parisc/kernel/time.c
> +++ b/arch/parisc/kernel/time.c
> @@ -173,7 +173,7 @@ EXPORT_SYMBOL(profile_pc);
> 
>  /* clock source code */
> 
> -static cycle_t read_cr16(void)
> +static cycle_t read_cr16(struct clocksource *cs)
>  {
>  	return get_cycles();
>  }
> 

