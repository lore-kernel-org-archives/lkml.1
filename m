Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYKFWBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYKFWBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYKFWBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:01:35 -0500
Received: from waste.org ([66.93.16.53]:42791 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbYKFWBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:01:34 -0500
Subject: Re: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
From: Matt Mackall <mpm@selenic.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ben Hutchings <bhutchings@solarflare.com>
In-Reply-To: <4912943C.2090801@zytor.com>
References: <4910C845.4060909@kernel.org> <20081106062608.GC6384@elte.hu>
	 <86802c440811052242taefec24ndf661b1c65ca457e@mail.gmail.com>
	 <4912943C.2090801@zytor.com>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 15:59:58 -0600
Message-Id: <1226008798.3023.23.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 22:52 -0800, H. Peter Anvin wrote:
> Yinghai Lu wrote:
> >>
> >> Clean-up sidenote: i think we can now remove the VISWS #ifdef portion
> >> for good? Mind sending a patch for that too?
> > 
> > could remove CONFIG_PARAVIRT too.. Jeremy?
> > 
> 
> This seems like a bad idea, especially for the embedded guys.

I'd actually really like to see us move to dynamically-allocated irq
tables as they're currently huge. But I haven't dug into it deeply
enough to see what sort of gotchas are involved.

-- 
Mathematics is the supreme nostalgia of our time.

