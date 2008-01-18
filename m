Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbYARCUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbYARCUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbYARCUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:20:31 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:46184 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbYARCU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:20:29 -0500
Date: Thu, 17 Jan 2008 21:19:08 -0500
From: Jeff Dike <jdike@addtoit.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [-mm Patch] uml: fix a building error
Message-ID: <20080118021908.GA10658@c2.user-mode-linux.org>
References: <20080117105606.ff89e9e9.akpm@linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE5E90DF@orsmsx423.amr.corp.intel.com> <20080117211437.GA7573@c2.user-mode-linux.org> <20080117214150.GA25872@linux-os.sc.intel.com> <20080117230802.GA9360@c2.user-mode-linux.org> <924EFEDD5F540B4284297C4DC59F3DEE62B45A@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE62B45A@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 03:17:38PM -0800, Pallipadi, Venkatesh wrote:
> >#define X X
> >
> >is a no-op, yes?
> >
> 
> Later there is code in generic.h which is doing
> #ifndef ioremap_wc
> #define ioremap_wc ioremap_nocache
> #endif

Ah, that makes a bit more sense.

It'd be nice if there was less of a WTF factor there, though.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

