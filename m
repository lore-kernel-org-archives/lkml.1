Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbZLVP7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbZLVP7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZLVP7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:59:39 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:49722 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZLVP7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:59:38 -0500
Date: Tue, 22 Dec 2009 09:58:31 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [this_cpu_xx V8 07/16] Module handling: Use this_cpu_xx to
 dynamically allocate counters
In-Reply-To: <4B2F2AE8.7060507@kernel.org>
Message-ID: <alpine.DEB.2.00.0912220957570.12163@router.home>
References: <20091218222617.384355422@quilx.com> <20091218222651.319887863@quilx.com> <4B2F2820.5030904@kernel.org> <4B2F2AE8.7060507@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009, Tejun Heo wrote:

> index 482efc8..9350577 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -16,8 +16,7 @@
>  #include <linux/kobject.h>
>  #include <linux/moduleparam.h>
>  #include <linux/tracepoint.h>
> -
> -#include <asm/local.h>
> +#include <linux/percpu.h>

This is going to break ringbuffer.c.

