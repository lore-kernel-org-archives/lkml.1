Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbXELTdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbXELTdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbXELTdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:33:37 -0400
Received: from www.osadl.org ([213.239.205.134]:58275 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755932AbXELTdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:33:36 -0400
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070512102350.04126320.akpm@linux-foundation.org>
References: <20070430102837.748238000@linutronix.de>
	 <20070511132846.5ebf4437.akpm@linux-foundation.org>
	 <200705112302.47726.rjw@sisk.pl> <200705112309.15996.rjw@sisk.pl>
	 <20070511235607.83ad0eb5.akpm@linux-foundation.org>
	 <1178959563.22481.126.camel@localhost.localdomain>
	 <20070512020056.a24cf472.akpm@linux-foundation.org>
	 <1178961489.22481.133.camel@localhost.localdomain>
	 <20070512030754.90488f79.akpm@linux-foundation.org>
	 <1178970253.22481.143.camel@localhost.localdomain>
	 <20070512095145.0cf58a57.akpm@linux-foundation.org>
	 <1178989302.22481.185.camel@localhost.localdomain>
	 <20070512102350.04126320.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Sat, 12 May 2007 21:36:18 +0200
Message-Id: <1178998578.4004.1.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 10:23 -0700, Andrew Morton wrote:
> On Sat, 12 May 2007 19:01:41 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Can you upload a snapshot of your current queue ?
> 
> Yeah, that's super-easy.  It just happens that it all compiles
> and runs at present ;)

Really ?

/home/tglx/work/kernel/hrtimers/linux-2.6.21/sound/pci/pcxhr/pcxhr.c: In function ‘pcxhr_trigger’:
/home/tglx/work/kernel/hrtimers/linux-2.6.21/sound/pci/pcxhr/pcxhr.c:640: error: expected expression before ‘<<’ token
/home/tglx/work/kernel/hrtimers/linux-2.6.21/sound/pci/pcxhr/pcxhr.c:642: error: expected expression before ‘==’ token
/home/tglx/work/kernel/hrtimers/linux-2.6.21/sound/pci/pcxhr/pcxhr.c:644: warning: ISO C90 forbids mixed declarations and code
/home/tglx/work/kernel/hrtimers/linux-2.6.21/sound/pci/pcxhr/pcxhr.c:645: error: expected expression before ‘>>’ token
/home/tglx/work/kernel/hrtimers/linux-2.6.21/sound/pci/pcxhr/pcxhr.c:653: error: ‘s’ undeclared (first use in this function)
/home/tglx/work/kernel/hrtimers/linux-2.6.21/sound/pci/pcxhr/pcxhr.c:653: error: (Each undeclared identifier is reported only once
/home/tglx/work/kernel/hrtimers/linux-2.6.21/sound/pci/pcxhr/pcxhr.c:653: error: for each function it appears in.)
/home/tglx/work/kernel/hrtimers/linux-2.6.21/sound/pci/pcxhr/pcxhr.c:653: warning: type defaults to ‘int’ in declaration of ‘type name’
/home/tglx/work/kernel/hrtimers/linux-2.6.21/sound/pci/pcxhr/pcxhr.c:653: error: request for member ‘link_list’ in something not a structure or union
/home/tglx/work/kernel/hrtimers/linux-2.6.21/sound/pci/pcxhr/pcxhr.c:653: warning: type defaults to ‘int’ in declaration of ‘__mptr’
/home/tglx/work/kernel/hrtimers/linux-2.6.21/sound/pci/pcxhr/pcxhr.c:653: warning: initialization from incompatible pointer type


