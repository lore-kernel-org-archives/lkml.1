Return-Path: <linux-kernel-owner+w=401wt.eu-S933398AbZJGNUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398AbZJGNUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933453AbZJGNUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:20:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50478 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933429AbZJGNUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:20:09 -0400
Date: Wed, 7 Oct 2009 14:19:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Samuel Ortiz <sameo@linux.intel.com>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and
 KeypadInput Device Driver
Message-ID: <20091007131931.GB18135@rakim.wolfsonmicro.main>
References: <20091006123658.GA31079@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F4420@limkexm3.ad.analog.com>
 <20091006135836.GA3926@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F46A7@limkexm3.ad.analog.com>
 <20091006144805.GA10987@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F4769@limkexm3.ad.analog.com>
 <20091006160549.GA8881@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F4CEE@limkexm3.ad.analog.com>
 <20091007100638.GB3169@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E443077@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0E443077@limkexm3.ad.analog.com>
X-Cookie: I smell a wumpus.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 02:01:42PM +0100, Hennerich, Michael wrote:

> Most architectures define NR_IRQS to exactly the number of on-chip IRQs.
> Therefore irq_desc pointers > NR_IRQS will fail on most architectures.
> This driver should be usable out of the box - but I guess this may
> prevent this.

Indeed, that's rather unfortunate.  This wouldn't be the only driver
with that dependency, though, so I'd expect to see the interesting
architectures getting fixed.
