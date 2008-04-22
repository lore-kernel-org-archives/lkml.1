Return-Path: <linux-kernel-owner+w=401wt.eu-S1765588AbYDVNvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765588AbYDVNvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbYDVNvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:51:31 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42170 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbYDVNva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:51:30 -0400
Subject: Re: BIOS bug, APIC version if 0 for CPU#0
From: Kasper Sandberg <lkml@metanurb.dk>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <dd18b0c30804212310h29938c02r86aaab49b327b550@mail.gmail.com>
References: <dd18b0c30804212213x74716d5fx4bf91cbb99a01286@mail.gmail.com>
	 <480D75EF.9040902@gmail.com>
	 <dd18b0c30804212310h29938c02r86aaab49b327b550@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 15:49:05 +0200
Message-Id: <1208872145.14146.103.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 06:10 +0000, Justin Mattock wrote:
> On Tue, Apr 22, 2008 at 5:21 AM, Jacek Luczak <difrost.kernel@gmail.com> wrote:
> > Hi,
> >
> >
> >  > Hello;
> >  > with the latest git on a macbook the system can barely boot without
> >  > freezing, a work around for me at leat is either disable smp, or once
> >  > booted  turn on glxgears,or compiling the kernel i.g. when using the
> >  > processors I'm not receiving a freeze, only when everything starts
> >  > lowering down. in dmesg I'm noticing BIOS bug, APIC version is 0 for
> >  > CPU#0! fixing up to 0x10. (tell you're hw vendor) could this be the
> >  > reason for the system freezes?,
> >
> >  I don't think so. On my machine there's no freezes with latest git and:
> >  ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> >  BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
> >  ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> >  BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
> >
> >  I've got exactly the same messages.
> 
> Are you using a macbook aswell?
> 
> >
> >
> >  > also I didnt have a camera handy on me
> >  > but the screen spit out = Bug spinlock lockup on CPU#0
> >  > swapper/0. c17fa7c0 PID 0, comm: swapper not tainted.
> >
> >  Can you try to write down more of those bug messages?
> 
> Yeah,
> 
> >
> >
> >  > I dont have a problem disabling smp, except when I cat /proc/cpuinfo I
> >  > don't see anything about my cores.
> >
> >  What exactly you expect to see in /proc/cpuinfp while smp is disabled?
> 
> under smp I see cpu cores. disabling smp I dont see cpu cores, under
> cat /proc/cpuinfo.

well.. SMP is kindof support for multiple processors, be it in one
socket, or multiple sockets.. without SMP you will only be able to use 1
of your X cores.
> 
> 
> >
> >
> >  > I know this is a stupid question
> >  > but will it hurt the system if smp is disabled
> >  > for the macbook pro ati chipset.?
> >
> >  No it won't.
> >
> >  -Jacek
> >
> 
> Cool as long as the system Is o.k. disabling smp.
It is.. but with the limitations outlined above.
>   What about x86: PAT
> support is disabled. how do I enable this option?
> regards;
> 

