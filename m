Return-Path: <linux-kernel-owner+w=401wt.eu-S932932AbZJFQG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbZJFQG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbZJFQG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:06:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57753 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757527AbZJFQG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:06:27 -0400
Date: Tue, 6 Oct 2009 17:05:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Samuel Ortiz <sameo@linux.intel.com>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and
 KeypadInput Device Driver
Message-ID: <20091006160549.GA8881@rakim.wolfsonmicro.main>
References: <1253682664-27040-1-git-send-email-vapier@gentoo.org>
 <1254815071-15822-1-git-send-email-vapier@gentoo.org>
 <20091006115543.GH27168@sirena.org.uk>
 <8A42379416420646B9BFAC9682273B6D0E3F4348@limkexm3.ad.analog.com>
 <20091006123658.GA31079@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F4420@limkexm3.ad.analog.com>
 <20091006135836.GA3926@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F46A7@limkexm3.ad.analog.com>
 <20091006144805.GA10987@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F4769@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0E3F4769@limkexm3.ad.analog.com>
X-Cookie: Haste makes waste.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 04:05:45PM +0100, Hennerich, Michael wrote:
> >From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]

> >According to the datasheet the GPIOs, light sensor and regulator can
> >also generate interrupts?

> Right - I know - but none of the subdevs are currently using this
> functionality.

You weren't very clear on the difference between the current state of
the drivers and the capabilities of the chip there.

> >The GPIOs in particular would benefit from
> >this since this would mean that their interrupts would be usable by
> >generic gpiolib based drivers.

> Right - and I didn't say that I'm not going to add this functionality
> later.
> All the ADP5520 subdevs already merged in 2.6.32 - the MFD core is the
> only remaining part.
> Time is running short and major changes are going to require another
> round of full testing.

Oh, well, that's sad.  It would have been worth at least considering 
doing something that at least looks like the IRQ infrastructure but now
there's going to be a merge issue with the input tree if anything gets
changed now.
