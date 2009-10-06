Return-Path: <linux-kernel-owner+w=401wt.eu-S932909AbZJFOsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909AbZJFOsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932857AbZJFOsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:48:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43268 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932802AbZJFOsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:48:45 -0400
Date: Tue, 6 Oct 2009 15:48:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Samuel Ortiz <sameo@linux.intel.com>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and
 KeypadInput Device Driver
Message-ID: <20091006144805.GA10987@rakim.wolfsonmicro.main>
References: <1253682664-27040-1-git-send-email-vapier@gentoo.org>
 <1254815071-15822-1-git-send-email-vapier@gentoo.org>
 <20091006115543.GH27168@sirena.org.uk>
 <8A42379416420646B9BFAC9682273B6D0E3F4348@limkexm3.ad.analog.com>
 <20091006123658.GA31079@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F4420@limkexm3.ad.analog.com>
 <20091006135836.GA3926@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F46A7@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0E3F46A7@limkexm3.ad.analog.com>
X-Cookie: Remember the... the... uhh.....
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 03:32:56PM +0100, Hennerich, Michael wrote:

> This is not an interrupt controller.
> The only ADP5520 subdev that needs to be notified is the adp5520-keys
> input driver, if present.
> Sounds like overshoot, registering a irq_chip using
> set_irq_chip_and_handler() and friends, for exactly one dedicated and
> known consumer.

According to the datasheet the GPIOs, light sensor and regulator can
also generate interrupts?  The GPIOs in particular would benefit from
this since this would mean that their interrupts would be usable by
generic gpiolib based drivers.  
