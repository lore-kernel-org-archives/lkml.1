Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYFKVkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYFKVkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 17:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYFKVkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 17:40:06 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:44651 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbYFKVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 17:40:05 -0400
Message-ID: <4850460C.5030406@nortel.com>
Date: Wed, 11 Jun 2008 15:39:24 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: markh@compro.net
CC: Arjan van de Ven <arjan@infradead.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
References: <200806102152.23286.solstice.dhiver@gmail.com> <20080610131314.5f7069e6@infradead.org>	<484EE71A.40002@intel.com> <alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr> <20080611063639.5e1eea5b@infradead.org> <alpine.LNX.1.10.0806111552090.20733@fbirervta.pbzchgretzou.qr> <20080611065816.6cff290d@infradead.org> <Pine.LNX.4.61.0806111006560.23096@chaos.analogic.com> <20080611083644.32afc823@infradead.org>	<4850046C.4070602@compro.net> <20080611104446.3b0ce2d9@infradead.org>	<48501159.4050908@compro.net> <48503792.50003@compro.net> <20080611135828.29f6a7d7@infradead.org> <48503EB9.6000606@compro.net>
In-Reply-To: <48503EB9.6000606@compro.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2008 21:39:29.0050 (UTC) FILETIME=[A08F1FA0:01C8CC0B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:

> If they are not the same how do you know at what rate the tsc is counting.

You don't, at least not easily.  The timekeeping subsystem knows, but it 
might be unstable, or change with cpu frequency or cpu going idle, etc.

> But back to "how usable is rdtsc for time", is there a
> 
> clock_gettime(CLOCK_MONOTONIC, &time) equivalent that can be used in the kernel?

With current kernels it looks like ktime_get_ts() should give exactly 
the same results, since it's how that userspace function is implemented. 
  With a stable tsc it seems like it should give full accuracy.

Chris
