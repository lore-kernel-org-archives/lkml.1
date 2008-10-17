Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYJQFXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYJQFXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 01:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYJQFW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 01:22:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:56329 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYJQFWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 01:22:55 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
In-Reply-To: <1224220339.7654.84.camel@pasglop>
References: <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop>
	 <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>
	 <20081016.210404.151891223.davem@davemloft.net>
	 <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
	 <1224220339.7654.84.camel@pasglop>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 16:21:38 +1100
Message-Id: <1224220898.7654.86.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 16:12 +1100, Benjamin Herrenschmidt wrote:
> +#ifdef CONFIG_X86
> +#define IO_RSRC_SIZE   4
> +#elif CONFIG_PPC
> +#define IO_RSRC_SIZE   8
> +#else
> +#define IO_RSRC_SIZE   MEM_RSRC_SIZE
> +#endif

And I'm obviously tired, the #elif CONFIG_PPC is bogus, feel free to fix
it up, else I'll send a new patch tomorrow or next week. No big deal.

Cheers,
Ben.


