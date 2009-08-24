Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZHXTim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZHXTim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 15:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZHXTil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 15:38:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52268 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753357AbZHXTik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 15:38:40 -0400
Date: Mon, 24 Aug 2009 20:38:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC patch 0/3] Support for irq chips on slow busses (i2c,
 spi) - V2
Message-ID: <20090824193840.GA9887@rakim.wolfsonmicro.main>
References: <20090815174512.491425246@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090815174512.491425246@linutronix.de>
X-Cookie: Who was that masked man?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 05:48:26PM -0000, Thomas Gleixner wrote:

> Please have a thorough look and hopefully a test ride on your
> favourite slowbus irq chip implementation so we can get this into .32

I've given this a spin with such a chip and it seems to be working OK
for me, though I've only done very light testing.  The only issue I ran
into was a lack of a prototype for handle_nested_irq() - I've sent a
patch for that.

Thanks a lot for working on this!
