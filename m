Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbXHTJbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbXHTJbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 05:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbXHTJbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 05:31:13 -0400
Received: from www.osadl.org ([213.239.205.134]:50778 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754822AbXHTJbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 05:31:13 -0400
Subject: Re: 2.6.23-rc3-hrt2 stall during boot on ASUS F3T (x86_64)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070820123559.3582f3bc@localhost>
References: <20070820104455.0dc7fe3d@localhost>
	 <1187592717.6114.170.camel@twins> <1187596481.7007.169.camel@chaos>
	 <20070820123559.3582f3bc@localhost>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 11:31:10 +0200
Message-Id: <1187602270.7007.173.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 12:35 +0400, Mikhail Kshevetskiy wrote:
> > > >   at 73.442744: I do nothing, the kernel continue to boot after 168 sec
> > > > 
> > > >   at 243.497822: After 2 hours i press and hold "shift" button to continue booting 
> > > > 
> > > > The dmesg output and my kernel configuration are listed below. 
> > > > 
> > > > I test i386 version of the same kernel with very similar configuration, it boot normally.
> > 
> > Can you please add "noapictimer" to the kernel command line ?
>
> This helps, thank you.
> Why it is not required for i386 kernel?
> Is it possible to fix this problem without disabling of apic timer?

Probably, but we need more information about the breakage. I assume that
the 64 bit kernel does something different with the power states on idle

Can you please provide the output of /proc/acpi/processor/CPU0/power for
both the 32 and the 64 bit kernel ?

	tglx


