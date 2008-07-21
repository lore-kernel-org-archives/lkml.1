Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYGUNZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYGUNZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYGUNZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:25:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:59201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbYGUNY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:24:59 -0400
Date: Mon, 21 Jul 2008 15:25:39 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <gregkh@suse.de>,
       kexec <kexec@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, kernel-testers@vger.kernel.org
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068
 trace_hardirqs_on_caller
Message-ID: <20080721152539.3d8684f9@halley.suse.de>
In-Reply-To: <20080721131721.GB4451@redhat.com>
References: <20080718195352.e562a00f.sfr@canb.auug.org.au>
	<200807190928.33978.m.kozlowski@tuxland.pl>
	<19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com>
	<19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com>
	<20080719221723.GB5578@suse.de>
	<19f34abd0807191527u61c5ed61kffe2279c8d46915d@mail.gmail.com>
	<19f34abd0807191544nfd73be5nf7dde4b61992a7e8@mail.gmail.com>
	<20080719225817.GA6264@suse.de>
	<19f34abd0807191611y7cabf405iad307ba79591e04f@mail.gmail.com>
	<1216544462.9311.20.camel@nimitz>
	<20080721131721.GB4451@redhat.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal [2008-07-21 09:17]:
> 
> Is /proc/iomem updated upon memory hotplug event.

Yes. I just checked that (yesterday).

I think it would make sense to extend /sys/firmware/memmap on
hot-plugging. Just because on reboot, the firmware will see that
memory, too, and report it. However, we need a way to discriminate the
originally firmware-provided memory map with later added memory. I'm
not sure how that can be done, I have to think about it.


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
