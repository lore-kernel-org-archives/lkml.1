Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbXK0WYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbXK0WYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXK0WYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:24:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40312 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbXK0WYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:24:09 -0500
Date: Tue, 27 Nov 2007 23:24:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>, Ben Woodard <woodard@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071127222408.GH24223@one.firstfloor.org>
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <20071127131355.GA14887@hmsendeavour.rdu.redhat.com> <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com> <200711271445.56792.ak@suse.de> <m1lk8jka8j.fsf@ebiederm.dsl.xmission.com> <474C64CB.7080004@redhat.com> <20071127194220.GG14887@hmsendeavour.rdu.redhat.com> <20071127200011.GA3703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127200011.GA3703@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Are we putting the system back in PIC mode or virtual wire mode? I have
> not seen systems which support PIC mode. All latest systems seems
> to be having virtual wire mode. I think in case of PIC mode, interrupts

Yes it's probably virtual wire. For real PIC mode we would need really
old systems without APIC.

> can be delivered to cpu0 only. In virt wire mode, one can program IOAPIC
> to deliver interrupt to any of the cpus and that's what we have been

The code doesn't try to program anything specific, it just restores the state
that was left over originally by the BIOS.

-Andi
