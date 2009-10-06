Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbZJFPG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbZJFPG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbZJFPG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:06:26 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:55714 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbZJFPGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:06:25 -0400
X-IronPort-AV: E=Sophos;i="4.44,513,1249272000"; 
   d="scan'208";a="7242481"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
Date: Tue, 6 Oct 2009 16:05:45 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0E3F4769@limkexm3.ad.analog.com>
In-Reply-To: <20091006144805.GA10987@rakim.wolfsonmicro.main>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
thread-index: AcpGlAjM/s1ZRxDtRoWFi1+6WVQJTQAACiZQ
References: <1253682664-27040-1-git-send-email-vapier@gentoo.org> <1254815071-15822-1-git-send-email-vapier@gentoo.org> <20091006115543.GH27168@sirena.org.uk> <8A42379416420646B9BFAC9682273B6D0E3F4348@limkexm3.ad.analog.com> <20091006123658.GA31079@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F4420@limkexm3.ad.analog.com> <20091006135836.GA3926@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F46A7@limkexm3.ad.analog.com> <20091006144805.GA10987@rakim.wolfsonmicro.main>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
CC: "Mike Frysinger" <vapier@gentoo.org>,
       "Samuel Ortiz" <sameo@linux.intel.com>,
       <uclinux-dist-devel@blackfin.uclinux.org>,
       <linux-kernel@vger.kernel.org>, "Bryan Wu" <cooloney@kernel.org>
X-OriginalArrivalTime: 06 Oct 2009 15:05:48.0463 (UTC) FILETIME=[7CB313F0:01CA4696]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>On Tue, Oct 06, 2009 at 03:32:56PM +0100, Hennerich, Michael wrote:
>
>> This is not an interrupt controller.
>> The only ADP5520 subdev that needs to be notified is the adp5520-keys
>> input driver, if present.
>> Sounds like overshoot, registering a irq_chip using
>> set_irq_chip_and_handler() and friends, for exactly one dedicated and
>> known consumer.
>
>According to the datasheet the GPIOs, light sensor and regulator can
>also generate interrupts?

Right - I know - but none of the subdevs are currently using this
functionality.

>The GPIOs in particular would benefit from
>this since this would mean that their interrupts would be usable by
>generic gpiolib based drivers.

Right - and I didn't say that I'm not going to add this functionality
later.
All the ADP5520 subdevs already merged in 2.6.32 - the MFD core is the
only remaining part.
Time is running short and major changes are going to require another
round of full testing.

-Michael

