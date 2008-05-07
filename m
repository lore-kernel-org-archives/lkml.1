Return-Path: <linux-kernel-owner+w=401wt.eu-S1766009AbYEGV4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766009AbYEGV4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbYEGV40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:56:26 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:62704 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612AbYEGV4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QYd0fUWscOVT+pIpmtcVQ2Y9ww8btNBjRhBZV1gUHW527LG09rPHI9jtMtbdPlqHm8rHLd3LRrEu788mmEpoZmS2M1/rA4loNA+4XUoPIeUOsHezwiT2fqLtrBouOMU2LXx8dNF/eSYYQu5wg9rDpqxgje1KjyP6v1GFiCCqTFc=
Message-ID: <dd18b0c30805071456j34ba30eeg7aeea843b91ea727@mail.gmail.com>
Date: Wed, 7 May 2008 21:56:21 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: BIOS bug, APIC version if 0 for CPU#0
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Kasper Sandberg" <lkml@metanurb.dk>,
       "Jacek Luczak" <difrost.kernel@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <200805072347.43805.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804212213x74716d5fx4bf91cbb99a01286@mail.gmail.com>
	 <200805070037.12796.rjw@sisk.pl> <4821089D.9080901@googlemail.com>
	 <200805072347.43805.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 9:47 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, 7 of May 2008, Gabriel C wrote:
>  > Rafael J. Wysocki wrote:
>  > > On Tuesday, 22 of April 2008, Justin Mattock wrote:
>  > >> On Tue, Apr 22, 2008 at 1:49 PM, Kasper Sandberg <lkml@metanurb.dk> wrote:
>  > >>> On Tue, 2008-04-22 at 06:10 +0000, Justin Mattock wrote:
>  > >>>  > On Tue, Apr 22, 2008 at 5:21 AM, Jacek Luczak <difrost.kernel@gmail.com> wrote:
>  > >>>  > > Hi,
>  > >>>  > >
>  > >>>  > >
>  > >>>  > >  > Hello;
>  > >>>  > >  > with the latest git on a macbook the system can barely boot without
>  > >>>  > >  > freezing, a work around for me at leat is either disable smp, or once
>  > >>>  > >  > booted  turn on glxgears,or compiling the kernel i.g. when using the
>  > >>>  > >  > processors I'm not receiving a freeze, only when everything starts
>  > >>>  > >  > lowering down. in dmesg I'm noticing BIOS bug, APIC version is 0 for
>  > >>>  > >  > CPU#0! fixing up to 0x10. (tell you're hw vendor) could this be the
>  > >>>  > >  > reason for the system freezes?,
>  > >>>  > >
>  > >>>  > >  I don't think so. On my machine there's no freezes with latest git and:
>  > >>>  > >  ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
>  > >>>  > >  BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
>  > >>>  > >  ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
>  > >>>  > >  BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
>  > >>>  > >
>  > >>>  > >  I've got exactly the same messages.
>  > >>>  >
>  > >>>  > Are you using a macbook aswell?
>  > >>>  >
>  > >>>  > >
>  > >>>  > >
>  > >>>  > >  > also I didnt have a camera handy on me
>  > >>>  > >  > but the screen spit out = Bug spinlock lockup on CPU#0
>  > >>>  > >  > swapper/0. c17fa7c0 PID 0, comm: swapper not tainted.
>  > >>>  > >
>  > >>>  > >  Can you try to write down more of those bug messages?
>  > >>>  >
>  > >>>  > Yeah,
>  > >>>  >
>  > >>>  > >
>  > >>>  > >
>  > >>>  > >  > I dont have a problem disabling smp, except when I cat /proc/cpuinfo I
>  > >>>  > >  > don't see anything about my cores.
>  > >>>  > >
>  > >>>  > >  What exactly you expect to see in /proc/cpuinfp while smp is disabled?
>  > >>>  >
>  > >>>  > under smp I see cpu cores. disabling smp I dont see cpu cores, under
>  > >>>  > cat /proc/cpuinfo.
>  > >>>
>  > >>>  well.. SMP is kindof support for multiple processors, be it in one
>  > >>>  socket, or multiple sockets.. without SMP you will only be able to use 1
>  > >>>  of your X cores.
>  > >> Yeah disabling smp is not a good idea on a macbook pro, performace is horrible.
>  > >>
>  > >>>  >
>  > >>>  >
>  > >>>  > >
>  > >>>  > >
>  > >>>  > >  > I know this is a stupid question
>  > >>>  > >  > but will it hurt the system if smp is disabled
>  > >>>  > >  > for the macbook pro ati chipset.?
>  > >>>  > >
>  > >>>  > >  No it won't.
>  > >>>  > >
>  > >>>  > >  -Jacek
>  > >>>  > >
>  > >>>  >
>  > >>>  > Cool as long as the system Is o.k. disabling smp.
>  > >>>  It is.. but with the limitations outlined above.
>  > >>>  >   What about x86: PAT
>  > >>>  > support is disabled. how do I enable this option?
>  > >>>  > regards;
>  > >>>  >
>  > >>>
>  > >>>
>  > >> Thanks for the feedback, well I guess this would be either a
>  > >> regression or a bug. I think the best would be to have somebody else
>  > >> with a macbook pro 15' ati chipset confirm this freezeing as well,
>  > >> before going out and jumping the gun, and filing a bug report.
>  > >> regards;
>  > >
>  > > What's the current status of this issue?
>  >
>  > I reported this issue too but got ignored .. No one of the x86 maintainer did answer my questions.
>  >
>  > http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/1258.html
>  >
>  > However it does not do any bad on my boxes ( so far I can tell ) is just plain annoying and wrong some who since
>  > is *only* occurs on 32bit kernels. HW is broken or even isn't.
>  >
>  > It seems to me this issue is related to the move of generic_processor_info() and fiends to apic_32.c ( but I'm not really sure ) ,
>  > all I'm sure about this message was not in 2.6.25 nor in 2.6.24.
>
>  It will be listed as http://bugzilla.kernel.org/show_bug.cgi?id=10613.
>
>  Please add yourself to the Cc list in there.
>
>  Thanks,
>  Rafael
>

Cool, thanks for informing me. As of now I've decided to revert to
2.6.25-rc9 due to it running smoothly on a macbook pro,
and everything working. I'll try a go at a later kernel, whenever ATI
decides to add support for fault.
regards;

-- 
Justin P. Mattock
