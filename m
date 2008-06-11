Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYFKNgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYFKNgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 09:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbYFKNgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 09:36:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:50271 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYFKNgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 09:36:44 -0400
Date: Wed, 11 Jun 2008 06:36:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
Message-ID: <20080611063639.5e1eea5b@infradead.org>
In-Reply-To: <alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr>
References: <200806102152.23286.solstice.dhiver@gmail.com>
	<20080610131314.5f7069e6@infradead.org>
	<484EE71A.40002@intel.com>
	<alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr>
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

On Wed, 11 Jun 2008 14:42:40 +0200 (CEST)
Jan Engelhardt <jengelh@medozas.de> wrote:

> 
> On Tuesday 2008-06-10 22:42, Kok, Auke wrote:
> >>>
> >>> and it appears that /proc/cpuinfo lack the line 
> >>> cpu MHz:
> >> 
> >> 
> >> btw this is scary; the Mhz line in /proc/cpuinfo doesn't have much
> >> meaning really, so applications using it and depending on it is a
> >> rather big disaster ;-(
> >> 
> >> Does anyone know why jackd wants to use this?
> 
> It would be nice to have a /sys file where the CPU frequency is in,

may I ask why? What would you do with it?
If it says 100Mhz, what would you conclude? That you have a slow cpu?
Or that you have a really fast CPU that currently runs at a low
frequency because you're mostly idle and are saving power?

CPU frequency is...
1) not something that is fixed; it changes all the time
2) not a good indication for performance; remember the 3.4Ghz pentium4,
a 2Ghz Core2Duo outperforms it
3) something which the cpu itself barely honors (the clock stops during
idle etc etc)

Userland apps that use "cpu frequency" seem to be buggy to me, at
least I don't believe that they understand the complexities about what
this means, and I don't believe that the decisions they make based on
this will be made correctly.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
