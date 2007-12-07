Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbXLGSwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbXLGSwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXLGSw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:52:27 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59727 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbXLGSw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:52:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Horman <nhorman@redhat.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Ben Woodard <woodard@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, hbabu@us.ibm.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <20071128160206.GA21286@hmsendeavour.rdu.redhat.com>
	<20071128190525.GD3192@redhat.com> <474F7177.7050306@redhat.com>
	<20071130144250.GC23810@redhat.com>
	<20071130145131.GB5822@hmsendeavour.rdu.redhat.com>
	<20071206213951.GB28898@hmsreliant.think-freely.org>
	<20071206221143.GC2863@redhat.com>
	<m1bq93s5r8.fsf@ebiederm.dsl.xmission.com>
	<86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com>
	<86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com>
	<20071207142144.GA10389@hmsendeavour.rdu.redhat.com>
Date: Fri, 07 Dec 2007 11:36:58 -0700
In-Reply-To: <20071207142144.GA10389@hmsendeavour.rdu.redhat.com> (Neil
	Horman's message of "Fri, 7 Dec 2007 09:21:44 -0500")
Message-ID: <m1y7c6qrlh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@redhat.com> writes:

> this seems reasonable, I can reroll the patch for this.  As I think about it I'm
> also going to update the patch to make this check occur for any pci class 0600
> device from vendor AMD, since its possible that more than just nvidia chipsets
> can be affected.
>
> I'll repost as soon as I've tested, thanks!

Thanks.

Neil in your testing please confirm the preconditions for setting 
the Apic Extended Broadcast flag (bit 17) are present.

If that is the case it makes sense to always set that bit on conforming
systems but we will also want to print a message noting that the
BIOS has a bug, and we are working around it.

Thanks,
Eric
