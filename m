Return-Path: <linux-kernel-owner+w=401wt.eu-S1761864AbYFKPhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761864AbYFKPhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761661AbYFKPgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:36:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:58695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761649AbYFKPgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:36:50 -0400
Date: Wed, 11 Jun 2008 08:36:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
Message-ID: <20080611083644.32afc823@infradead.org>
In-Reply-To: <Pine.LNX.4.61.0806111006560.23096@chaos.analogic.com>
References: <200806102152.23286.solstice.dhiver@gmail.com>
	<20080610131314.5f7069e6@infradead.org>
	<484EE71A.40002@intel.com>
	<alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr>
	<20080611063639.5e1eea5b@infradead.org>
	<alpine.LNX.1.10.0806111552090.20733@fbirervta.pbzchgretzou.qr>
	<20080611065816.6cff290d@infradead.org>
	<Pine.LNX.4.61.0806111006560.23096@chaos.analogic.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 10:14:50 -0400
"linux-os (Dick Johnson)" <linux-os@analogic.com> wrote:

> 
> I use CPU frequency to scale the output of rdtsc when timing
> routines being optimized.

Ok this is broken in various really bad ways.

1) CPU frequency is very fluctuating, it changes in principle every
millisecond or more
2) the rdtsc "frequency" is conceptually unrelated to cpu frequency. In
fact, you'll be hard-pressed to buy a system today where this
relationship works....


> If CPU frequency goes away, I'll
> have to add calibration routines to a lot of code. I don't
> think one should just dispose of something that has been
> useful for many years because they don't understand its
> utility.

clearly you don't understand it either ;-)

I'm not arguing for removing it, at all. I'm just arguing that any user
of it (being human or program) has some problems in how they use the
data.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
