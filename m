Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbYFKV25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbYFKV25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 17:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYFKV2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 17:28:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:37619 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbYFKV2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 17:28:49 -0400
Date: Wed, 11 Jun 2008 14:28:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: markh@compro.net
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
Message-ID: <20080611142840.47d65782@infradead.org>
In-Reply-To: <48503EB9.6000606@compro.net>
References: <200806102152.23286.solstice.dhiver@gmail.com>
	<20080610131314.5f7069e6@infradead.org>
	<484EE71A.40002@intel.com>
	<alpine.LNX.1.10.0806111440480.20733@fbirervta.pbzchgretzou.qr>
	<20080611063639.5e1eea5b@infradead.org>
	<alpine.LNX.1.10.0806111552090.20733@fbirervta.pbzchgretzou.qr>
	<20080611065816.6cff290d@infradead.org>
	<Pine.LNX.4.61.0806111006560.23096@chaos.analogic.com>
	<20080611083644.32afc823@infradead.org>
	<4850046C.4070602@compro.net>
	<20080611104446.3b0ce2d9@infradead.org>
	<48501159.4050908@compro.net>
	<48503792.50003@compro.net>
	<20080611135828.29f6a7d7@infradead.org>
	<48503EB9.6000606@compro.net>
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

On Wed, 11 Jun 2008 17:08:09 -0400
Mark Hounschell <markh@compro.net> wrote:

> > 
> > btw you also changed the problem from "what is the cpu frequency" to
> > "how usable is rdtsc for time". My entire point was that these
> > weren't related...
> > 
> > 
> 
> If they are not the same how do you know at what rate the tsc is
> counting.

it's not ticking at the cpu frequency as general rule.
For current cpus, your best bet is to calibrate against some external
time source... it'll stay constant after that, unless you go to idle,
then it may or may not stop (or both). For older cpus it'll change with
frequency changes.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
