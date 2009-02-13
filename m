Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbZBMRwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbZBMRwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 12:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZBMRwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 12:52:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZBMRwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 12:52:46 -0500
Message-ID: <4995B35F.5080708@zytor.com>
Date: Fri, 13 Feb 2009 09:52:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] x86: memtest: introduce array to store memtest patterns
References: <20090213144600.GA6298@alberich.amd.com> <20090213145124.GB13000@alberich.amd.com>
In-Reply-To: <20090213145124.GB13000@alberich.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> -#define _MAX_MEM_PATTERNS 4
> +static unsigned long patterns[] = {
> +	0UL,
> +	-1UL,
> +#ifdef CONFIG_X86_64
> +	0x5555555555555555UL,
> +	0xaaaaaaaaaaaaaaaaUL,
> +#else
> +	0x55555555UL,
> +	0xaaaaaaaaUL,
> +#endif
> +};

Why not just use u64 for the pattern even on 32 bits?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

