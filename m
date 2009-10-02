Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZJBPYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZJBPYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 11:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZJBPYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 11:24:17 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:26708 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZJBPYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 11:24:16 -0400
X-IronPort-AV: E=Sophos;i="4.44,494,1249272000"; 
   d="scan'208";a="5271773"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Uclinux-dist-devel] [PATCH v2] mfd: ADP5520MultifunctionLCDBacklight and Keypad Input Device Driver
Date: Fri, 2 Oct 2009 16:24:17 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0E33B3A5@limkexm3.ad.analog.com>
In-Reply-To: <20091002143851.GD11133@sirena.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [Uclinux-dist-devel] [PATCH v2] mfd: ADP5520MultifunctionLCDBacklight and Keypad Input Device Driver
thread-index: AcpDbhQ+qmefw3rSRrOx5InIM/11hwABZxGw
References: <8A42379416420646B9BFAC9682273B6D0E33AC35@limkexm3.ad.analog.com> <8A42379416420646B9BFAC9682273B6D0E33B1AA@limkexm3.ad.analog.com> <20091002142725.GC11133@sirena.org.uk> <8A42379416420646B9BFAC9682273B6D0E33B2B6@limkexm3.ad.analog.com> <20091002143851.GD11133@sirena.org.uk>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
CC: "Samuel Ortiz" <sameo@linux.intel.com>,
       "Mike Frysinger" <vapier@gentoo.org>, <tglx@linutronix.de>,
       <uclinux-dist-devel@blackfin.uclinux.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Oct 2009 15:24:19.0637 (UTC) FILETIME=[695BC650:01CA4374]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>On Fri, Oct 02, 2009 at 03:37:15PM +0100, Hennerich, Michael wrote:
>
>> So I guess your patch won't work on 2.6.31
>
>Yes, it doesn't work in 2.6.31 - I waited until the relevant genirq
>stuff had hit mainline before I submitted it.
>
>> >This is essentially what a threaded IRQ handler does with current
>> >mainline.  There were issues in 2.6.31 but I believe all Thomas'
fixes
>> >have been merged now.
>
>> Do you know when they merged?
>> They are not in latest staple 2.6.31.1.
>
>2.6.32.

Thanks! IRQF_ONESHOT does the trick.

-Michael
