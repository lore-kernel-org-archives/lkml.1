Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbXK1ASA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbXK1ASA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 19:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbXK1ARx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 19:17:53 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56094 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbXK1ARw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:17:52 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ben Woodard <woodard@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       kexec@lists.infradead.org, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com, vgoyal@in.ibm.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <20071127014740.GA28622@hmsreliant.think-freely.org>
	<200711271445.56792.ak@suse.de>
	<20071127142826.GB31376@hmsreliant.think-freely.org>
	<200711271543.11809.ak@suse.de>
	<20071127144856.GC31376@hmsreliant.think-freely.org>
	<m14pf7k8ns.fsf@ebiederm.dsl.xmission.com>
	<474C832C.1060903@redhat.com>
	<20071127210558.GI14887@hmsendeavour.rdu.redhat.com>
	<m1r6ibia9v.fsf@ebiederm.dsl.xmission.com> <474CA520.60804@redhat.com>
Date: Tue, 27 Nov 2007 17:15:06 -0700
In-Reply-To: <474CA520.60804@redhat.com> (Ben Woodard's message of "Tue, 27
	Nov 2007 15:15:44 -0800")
Message-ID: <m1d4tvi5th.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Woodard <woodard@redhat.com> writes:

> Eric W. Biederman wrote:
>> Neil Horman <nhorman@redhat.com> writes:
>>
>>>> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
>>
>> Ben, what chipset is this?
>
> nVidia MCP55 pro
>
> It is the original version of
> http://www.supermicro.com/Aplus/motherboard/Opteron8000/MCP55/H8QM8-2.cfm
>
> i.e. not the -2. However, they don't seem to advertise the original
> version. Supermicro assures me that they are practically the same but I haven't
> played with the -2 version yet.
>

That is enough for an initial approximation.  Unless something has
changed radically the Nvidia chipsets can put the ioapic instead of
the local apic in virtual wire mode so that is worth testing.

Eric
