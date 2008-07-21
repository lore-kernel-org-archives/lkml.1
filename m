Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYGUNm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYGUNm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYGUNmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:42:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbYGUNmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:42:19 -0400
Date: Mon, 21 Jul 2008 09:39:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <gregkh@suse.de>,
       kexec <kexec@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, kernel-testers@vger.kernel.org
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068
	trace_hardirqs_on_caller
Message-ID: <20080721133937.GC4451@redhat.com>
References: <19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com> <19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com> <20080719221723.GB5578@suse.de> <19f34abd0807191527u61c5ed61kffe2279c8d46915d@mail.gmail.com> <19f34abd0807191544nfd73be5nf7dde4b61992a7e8@mail.gmail.com> <20080719225817.GA6264@suse.de> <19f34abd0807191611y7cabf405iad307ba79591e04f@mail.gmail.com> <1216544462.9311.20.camel@nimitz> <20080721131721.GB4451@redhat.com> <20080721152539.3d8684f9@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721152539.3d8684f9@halley.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 03:25:39PM +0200, Bernhard Walle wrote:
> * Vivek Goyal [2008-07-21 09:17]:
> > 
> > Is /proc/iomem updated upon memory hotplug event.
> 
> Yes. I just checked that (yesterday).
> 
> I think it would make sense to extend /sys/firmware/memmap on
> hot-plugging. Just because on reboot, the firmware will see that
> memory, too, and report it. However, we need a way to discriminate the
> originally firmware-provided memory map with later added memory. I'm
> not sure how that can be done, I have to think about it.

Probably use another type of RAM identifier (System RAM (hotplug)).

But the point is, if /sys/devices/system/memory also represents all
the physical memory present in the system then it might be not be
justified to create another similar interface. (Until and unless there
is something unique about /sys/firmware/memmap).

Thanks
Vivek
