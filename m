Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbXIYJa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbXIYJa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXIYJaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:30:21 -0400
Received: from www.osadl.org ([213.239.205.134]:35462 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751414AbXIYJaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:30:21 -0400
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325,
	related to clockevents
From: Thomas Gleixner <tglx@linutronix.de>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J.Wysocki" <rjw@sisk.pl>,
       Dave Jones <davej@redhat.com>, Chuck Ebbert <cebbert@redhat.com>
In-Reply-To: <1190707673.4035.275.camel@chaos>
References: <20070925101418.68d30a72@localhost>
	 <1190707673.4035.275.camel@chaos>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 11:30:18 +0200
Message-Id: <1190712618.4035.286.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Tue, 2007-09-25 at 10:07 +0200, Thomas Gleixner wrote:
> On Tue, 2007-09-25 at 10:14 +0400, Mikhail Kshevetskiy wrote:
> > Hello Thomas, Rafael
> > 
> > > We know, that
> > > - disabling local apic timers work
> > 
> > As i can see from the log, you are booting on computer with dualcore AMD
> > processor. Do you have C1E feature enabled? 
> > 
> > i386 kernel disable lapic on dualcore AMD with C1E support (see 
> > http://lkml.org/lkml/2007/3/29/199). x86_64 kernel do not have this
> > patch still (it's required for tickless kernel only).
> 
> Well it is required for non tickless mode as well.
> 
> >  As result, if
> > you run x86_64 kernel with hrt patch on such computer, the system
> > will stall during boot on lapic timer calibration.
> 
> Thanks for the reminder. I have a look into this.

Can you please boot mainline and provide the output of:

# cat /proc/interrupts; sleep 10; cat /proc/interrupts

Thanks,

	tglx


