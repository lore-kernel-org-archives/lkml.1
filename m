Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbYBIDtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbYBIDtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 22:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYBIDtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 22:49:05 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:12867 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbYBIDtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 22:49:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CO0xd3hPigbDMivCbJGPNEBpCjw0g1GqUapkkiacfypvEosaxFJELe3z9GRKAgVIFvO+pBLHzfd4pLMXvmjCvOrQ/zwes/Yd8ZM9LNNMTtOd1T/6RZIJsnC2UgNlTRujsh3Uk/V92e0OTjsK1qZqsXG7k+oJB32NgbGanMexkts=
Message-ID: <fa0147d90802081948j3fc27647pa549bcf09c913003@mail.gmail.com>
Date: Fri, 8 Feb 2008 19:48:58 -0800
From: Taral <taralx@gmail.com>
To: "Michael Opdenacker" <michael-lists@free-electrons.com>
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for some processors
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Matt Mackall" <mpm@selenic.com>, Linux-tiny@selenic.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <200802082347.25364.michael-lists@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802082347.25364.michael-lists@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/08, Michael Opdenacker <michael-lists@free-electrons.com> wrote:
> +config CPU_SUP_INTEL
> +       default y
> +       bool "Support Intel processors" if PROCESSOR_SELECT
> +       help
> +         This enables extended support for Intel processors

> -obj-$(CONFIG_X86_32)   += intel.o
> +obj-$(CONFIG_CPU_SUP_INTEL)    += intel.o

This config option should probably depend on X86_32.

-- 
Taral <taralx@gmail.com>
"Please let me know if there's any further trouble I can give you."
    -- Unknown
