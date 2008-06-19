Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYFSF2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYFSF2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 01:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYFSF2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 01:28:24 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:38085 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbYFSF2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 01:28:23 -0400
Date: Thu, 19 Jun 2008 01:27:38 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] x86: update mptable v7
In-reply-to: <m1mylim4e6.fsf@frodo.ebiederm.org>
X-X-Sender: lenb@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0806190121210.3613@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200805041823.57198.yhlu.kernel@gmail.com>
 <200805191252.36814.yhlu.kernel@gmail.com>
 <200805251600.26325.yhlu.kernel@gmail.com>
 <200806011317.38622.yhlu.kernel@gmail.com>
 <alpine.LFD.1.10.0806181812580.3074@localhost.localdomain>
 <86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>
 <alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>
 <86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com>
 <m1mylim4e6.fsf@frodo.ebiederm.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> >>> > Is this an effort to boot an ACPI-mode kernel,
> >>> > and then kexec a non-ACPI kernel?
> >>>
> >>> Yes,
> >>
> >> Why is this feature needed?
> >> There are a number of ways that the resulting kernel may fail,
> >> all platform specific.
> >
> > other os still doesn't have update acpi irq routing support. but has
> > broken mptable.
> 
> Which is at least in part a reason to go back to the BIOS manufacturer
> and get them to fix their table.

Who says it is broken?

> I can see a warning coming from the kernel if these two tables are inconsistent
> though.

Again, there may not *be* an MPS table, and if there is but the
interrupt links are programmable, the MPS table may have very little
in common with the state of the machine in ACPI mode.

I'm sorry, kexec continues to sound like science fiction to me.
I don't understand why scribbling on upstream Linux in the name
of science fiction makes any sense.

I just don't get it.

-Len

