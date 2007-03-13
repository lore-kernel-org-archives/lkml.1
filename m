Return-Path: <linux-kernel-owner+w=401wt.eu-S933200AbXCMUjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbXCMUjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933230AbXCMUjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:39:41 -0400
Received: from www.osadl.org ([213.239.205.134]:43136 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933200AbXCMUjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:39:40 -0400
Subject: Re: [6/6] 2.6.21-rc3: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephane Casset <sept@logidee.com>, Jiri Slaby <jirislaby@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>, Tejun Heo <htejun@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org
In-Reply-To: <20070313125025.GW18731@stusta.de>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	 <20070313125025.GW18731@stusta.de>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 21:46:17 +0100
Message-Id: <1173818777.13341.128.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 13:50 +0100, Adrian Bunk wrote:
> This email lists some known regressions in Linus' tree compared to 2.6.20.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way
> possibly involved with one or more of these issues.
> 
> Due to the huge amount of recipients, please trim the Cc when answering.
> Subject    : Clocksource tsc unstable (delta = -154983451 ns)
> References : http://lkml.org/lkml/2007/3/9/271
> Submitter  : Jiri Slaby <jirislaby@gmail.com>
> Status     : unknown

That's not a regression. That's an informal message, when the TSC
watchdog detects that the TSC is unreliable. 

	tglx


