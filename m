Return-Path: <linux-kernel-owner+w=401wt.eu-S934475AbZJIWTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934475AbZJIWTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 18:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934014AbZJIWTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 18:19:24 -0400
Received: from mga07.intel.com ([143.182.124.22]:45223 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751410AbZJIWTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 18:19:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,534,1249282800"; 
   d="scan'208";a="197219129"
Date: Sat, 10 Oct 2009 00:20:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v4] mfd: ADP5520 Multifunction LCD
 Backlight and Keypad Input Device Driver
Message-ID: <20091009222012.GD7523@sortiz.org>
References: <1254988727-31726-1-git-send-email-vapier@gentoo.org>
 <20091009153219.GB7523@sortiz.org>
 <8bd0f97a0910091323x7392ccdcxf54f74d7f454110f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0910091323x7392ccdcxf54f74d7f454110f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Fri, Oct 09, 2009 at 04:23:42PM -0400, Mike Frysinger wrote:
> On Fri, Oct 9, 2009 at 11:36, Samuel Ortiz wrote:
> > On Thu, Oct 08, 2009 at 03:58:47AM -0400, Mike Frysinger wrote:
> >> From: Michael Hennerich <michael.hennerich@analog.com>
> >>
> >> Base driver for Analog Devices ADP5520/ADP5501 MFD PMICs
> >>
> >> Subdevs:
> >> LCD Backlight   : drivers/video/backlight/adp5520_bl
> >> LEDs            : drivers/led/leds-adp5520
> >> GPIO            : drivers/gpio/adp5520-gpio (ADP5520 only)
> >> Keys            : drivers/input/keyboard/adp5520-keys (ADP5520 only)
> >
> > With your mfd core patch applied, adp5520-gpio.c and adp5520_bl.c are supposed
> > to be buildable. Unfortunately, they both give build errors.
> > So, you either provide me with a patch that fixes both of those, and I carry
> > it with my mfd patchset, or you get your fixes applied upstream and I apply
> > the mfd core patch after that.
> 
> yes, the typo fixes in this patch had pieces propagate to the other
> drivers.  if you dont mind carrying the other patchsets, i can send
> them all to you ;). 
Yes, I'm fine with that solution.

Thanks in advance.

Cheers,
Samuel.


> there should be like 3 or 4 of them.
> -mike

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
