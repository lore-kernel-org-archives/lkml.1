Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbZHSPAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbZHSPAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZHSPAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:00:04 -0400
Received: from www.tglx.de ([62.245.132.106]:46521 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZHSPAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:00:03 -0400
Date: Wed, 19 Aug 2009 16:59:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 5/10] x86: add moorestown related setup code
In-Reply-To: <43F901BD926A4E43B106BF17856F0755643EBDF7@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0908191656390.3361@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F0755643EBDF7@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob,

On Thu, 16 Jul 2009, Pan, Jacob jun wrote:

> + *
> + * Note:

  No note :)
  
> + *
> + */
> +
> +#include <asm/platform_feature.h>
> +#include <asm/apb_timer.h>
> +#include <asm/setup.h>
> +#include <asm/apic.h>
> +
> +static int __init mrst_pre_intr_init(void)
> +{
> +#ifdef CONFIG_X86_IO_APIC
> +	if (platform_has(X86_PLATFORM_FEATURE_APBT)) {

Sigh. You set that bit 10 lines further down

> -struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
> +struct x86_quirks *x86_quirks = &default_x86_quirks;

Eek. Why do we need to keep that ?

Thanks,

	tglx
