Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbYDPFWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbYDPFWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 01:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYDPFWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 01:22:40 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:43511 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbYDPFWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 01:22:39 -0400
Date: Wed, 16 Apr 2008 01:21:32 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/5] Clocklib: add generic framework for managing
 clocks.
Message-ID: <20080416012132.2caaa3e0@siona.local>
In-Reply-To: <20080414231330.b72cd746.akpm@linux-foundation.org>
References: <20080413144138.GA31665@doriath.ww600.siemens.net>
	<20080413144312.GA1943@doriath.ww600.siemens.net>
	<20080414231330.b72cd746.akpm@linux-foundation.org>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Apr 2008 05:21:37.0312 (UTC) FILETIME=[BE586200:01C89F81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 23:13:30 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Anyway, this patchset is basically an arm-only thing, so I'll need
> guidance, please...

As soon as any drivers starts using the dynamic clock registration API
introduced by these patches, other architectures will be sort of forced
to care about it...

I consider switching to clklib on avr32 regardless of this...though I
haven't really started that work yet.

But if Russell want to merge this initial dump through the ARM tree, I'm
perfectly fine with that, even if this library is intended to be
architecture-neutral.

Haavard
