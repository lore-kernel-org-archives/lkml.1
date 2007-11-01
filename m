Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbXKAEIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbXKAEIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 00:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbXKAEIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 00:08:12 -0400
Received: from gw.goop.org ([64.81.55.164]:48793 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbXKAEIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 00:08:11 -0400
Message-ID: <47295123.9010603@goop.org>
Date: Wed, 31 Oct 2007 21:08:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH/RFC] x86: unify Kconfig files
References: <20071031215501.GA28556@uranus.ravnborg.org>
In-Reply-To: <20071031215501.GA28556@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> It has been requested that we should let x86 behave like
> other architectures so we at config time decide for 32 or 64 bit.
> The challenge here is to mere the Kconfig files and I have done
> an attempt to do so.
>
> +source "mm/Kconfig"
>  
> -config X86_VISWS_APIC
> +config HIGHPTE
> +	bool "Allocate 3rd-level pagetables from highmem"
> +	depends on X86_32 && HIGHMEM4G || HIGHMEM64G
>   

Some parens: X86_32 && (HIGHMEM4G || HIGHMEM64G)?

    J
