Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbZJGNfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbZJGNfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758196AbZJGNfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:35:48 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:36604 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052AbZJGNfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:35:47 -0400
X-IronPort-AV: E=Sophos;i="4.44,519,1249272000"; 
   d="scan'208";a="5471356"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
Date: Wed, 7 Oct 2009 14:35:06 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0E44312E@limkexm3.ad.analog.com>
In-Reply-To: <20091007131931.GB18135@rakim.wolfsonmicro.main>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
thread-index: AcpHUOG7mVqU0RAFRDOeRNEpiGNUdAAAUqew
References: <20091006123658.GA31079@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F4420@limkexm3.ad.analog.com> <20091006135836.GA3926@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F46A7@limkexm3.ad.analog.com> <20091006144805.GA10987@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F4769@limkexm3.ad.analog.com> <20091006160549.GA8881@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F4CEE@limkexm3.ad.analog.com> <20091007100638.GB3169@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E443077@limkexm3.ad.analog.com> <20091007131931.GB18135@rakim.wolfsonmicro.main>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>
CC: "Mike Frysinger" <vapier@gentoo.org>,
       "Samuel Ortiz" <sameo@linux.intel.com>,
       <uclinux-dist-devel@blackfin.uclinux.org>,
       <linux-kernel@vger.kernel.org>, "Bryan Wu" <cooloney@kernel.org>
X-OriginalArrivalTime: 07 Oct 2009 13:35:09.0598 (UTC) FILETIME=[FD4BE3E0:01CA4752]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>
>On Wed, Oct 07, 2009 at 02:01:42PM +0100, Hennerich, Michael wrote:
>
>> Most architectures define NR_IRQS to exactly the number of on-chip
IRQs.
>> Therefore irq_desc pointers > NR_IRQS will fail on most
architectures.
>> This driver should be usable out of the box - but I guess this may
>> prevent this.
>
>Indeed, that's rather unfortunate.  This wouldn't be the only driver
>with that dependency, though, so I'd expect to see the interesting
>architectures getting fixed.

We have an update patch that fixes the platform typo and namespace
pollution in the header file.
I think we send out this patch as final for mainline inclusion.
For the interrupt controller feature - I think I can wait until the
interesting architectures get fixed.

Thanks for your feedback and help
best regards,
Michael 
 
