Return-Path: <linux-kernel-owner+w=401wt.eu-S1758445AbYFKU4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445AbYFKU4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYFKUzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:55:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:36986 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494AbYFKUzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:55:45 -0400
Date: Wed, 11 Jun 2008 13:55:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: markh@compro.net
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
Message-ID: <20080611135532.651fb5ae@infradead.org>
In-Reply-To: <48503792.50003@compro.net>
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

On Wed, 11 Jun 2008 16:37:38 -0400
> > Mark 
> > 
> 
> Ok, what would one use besides the tsc to take a fast high-res time
> stamp in a kernel module that could also be used in user land (same
> time source) to for instance calculate  the the time between an event
> in the kernel to an event in user land?
> 
> do_gettimeofday / gettimeofday are not really acceptable.


why not? both of these (they're teh same) are the best the kernel can
do. If there was a better way to do it, gettimeofday() would use it.
It's not even a system call if we can get away with it
(although system calls are pretty cheap)

really, think about it. if there was a better way, gettimeofday() would
use it.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
