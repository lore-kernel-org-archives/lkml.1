Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbXEJHo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbXEJHo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 03:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbXEJHoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 03:44:23 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:64681 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756587AbXEJHoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 03:44:22 -0400
Date: Thu, 10 May 2007 09:44:18 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/3] powerpc: Fixup hard_irq_disable semantics
In-Reply-To: <20070510052620.EC36DDDF92@ozlabs.org>
Message-ID: <Pine.LNX.4.62.0705100942590.32241@pademelon.sonytel.be>
References: <20070510052620.EC36DDDF92@ozlabs.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Benjamin Herrenschmidt wrote:
> This patch renames the raw hard_irq_{enable,disable} into
> __hard_irq_{enable,disable} and introduces a higher level
> hard_irq_disable() function that can be used by any code
> to enforce that IRQs are fully disabled, not only lazy
> disabled.

Why did you rename hard_irq_enable() too?

Isn't it more logical to have high-level hard_irq_disable() and
hard_irq_enable(), and a special low-level __hard_irq_disable()?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
