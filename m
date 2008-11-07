Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYKGSdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYKGSdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYKGSdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:33:25 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:55662 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYKGSdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:33:24 -0500
Date: Fri, 7 Nov 2008 12:32:53 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: next-20081106: undefined reference to `__per_cpu_start'
In-Reply-To: <20081106223417.GA26686@x200.localdomain>
Message-ID: <Pine.LNX.4.64.0811071229450.5387@quilx.com>
References: <20081106173645.e7e79071.sfr@canb.auug.org.au>
 <20081106183939.GA26925@x200.localdomain> <Pine.LNX.4.64.0811061310350.6009@quilx.com>
 <20081106223417.GA26686@x200.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008, Alexey Dobriyan wrote:

> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -51,6 +51,8 @@
>  #define DEFINE_PER_CPU_FIRST(type, name)				\
>  	DEFINE_PER_CPU(type, name)
>
> +#define PERCPU_AREA_SIZE 0
> +
>  #endif /* !CONFIG_SMP */
>
>  #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)

No we need a percpu allocation area even on UP.

