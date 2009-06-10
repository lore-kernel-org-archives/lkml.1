Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbZFJWHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbZFJWHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZFJWHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:07:04 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37685 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZFJWHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:07:02 -0400
Message-ID: <4A302E83.8060807@linux.vnet.ibm.com>
Date: Wed, 10 Jun 2009 15:06:59 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
References: <1244490680.6691.1.camel@laptop> <4A2D8011.9050502@linux.vnet.ibm.com>	<1244496223.6691.2.camel@laptop> <4A2D82CE.9000206@linux.vnet.ibm.com>	<20090608215002.GB22049@elte.hu> <4A2DB1C6.6090209@linux.vnet.ibm.com>	<20090609065117.GA16707@elte.hu> <4A2E19A9.3070201@linux.vnet.ibm.com>	<20090609115346.GB3062@elte.hu> <4A2E9157.2030108@linux.vnet.ibm.com>	<20090609220020.GA26526@elte.hu> <4A2EED64.9070605@linux.vnet.ibm.com> <18990.64229.961985.491166@cargo.ozlabs.ibm.com>
In-Reply-To: <18990.64229.961985.491166@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Corey Ashford writes:
> 
>> Ok, some disclosure here: we have not yet supported either of these features in 
>> the Power PMU's in any open source code (and perhaps the proprietary code too, 
>> but I don't know about that).  Since these features are described in an IBM 
>> proprietary document, I can't describe how they work here, except to say that 
>> they are present in the chip.
> 
> Actually, the public PPC970FX user manual has a chapter on the
> performance monitor unit which describes both thresholding and the
> instruction matching CAM, among other things.

Ah, good point!

Anyone interested can find the 970FX (G5) manual here: www.cs.lth.se/EDA116/G5.pdf
It's supposed to be on the IBM web site too, but for some reason, the link is 
broken (reported!).

> 
> I think we can support thresholding using higher-order bits of the
> event code when the low bits == PM_THRESH_TIMEO.  We can only have one
> PM_THRESH_TIMEO event on the PMU at any given time, so there can't be
> any conflict over the thresholder settings.
> 
> The IMC is more problematic, but we can't do much with it on POWER5
> and later processors anyway, due to various things being accessible
> only in hypervisor mode, so I have been ignoring it. :)
> 
> Paul.

Ug.  Well, there's always bare-metal Linux :)

- Corey

