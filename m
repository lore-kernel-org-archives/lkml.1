Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbYDOGOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbYDOGOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbYDOGOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:14:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbYDOGOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:14:33 -0400
Date: Mon, 14 Apr 2008 23:13:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/5] Clocklib: add generic framework for managing
 clocks.
Message-Id: <20080414231330.b72cd746.akpm@linux-foundation.org>
In-Reply-To: <20080413144312.GA1943@doriath.ww600.siemens.net>
References: <20080413144138.GA31665@doriath.ww600.siemens.net>
	<20080413144312.GA1943@doriath.ww600.siemens.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 18:43:12 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> +#define FUNC_TO_CLK(func)	&(&(struct clk_function) func)->clk

scratched my head for a while, was unable to work out what this does.
It is unused, so I think it can be zapped?

All the inlined functions in clklib.h are waaaaaaaaaaaay too big
to be inlined.  Did I fail to notice that last time around?

Anyway, this patchset is basically an arm-only thing, so I'll need
guidance, please...
