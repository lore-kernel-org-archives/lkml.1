Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbXK0LWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbXK0LWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 06:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbXK0LWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 06:22:36 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38574 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbXK0LWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 06:22:35 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <andi@firstfloor.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, kexec@lists.infradead.org, ak@suse.de,
       vgoyal@in.ibm.com, hbabu@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <20071127014740.GA28622@hmsreliant.think-freely.org>
	<20071127105503.GD24223@one.firstfloor.org>
Date: Tue, 27 Nov 2007 04:19:48 -0700
In-Reply-To: <20071127105503.GD24223@one.firstfloor.org> (Andi Kleen's message
	of "Tue, 27 Nov 2007 11:55:03 +0100")
Message-ID: <m1lk8kkka3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> On Mon, Nov 26, 2007 at 08:47:40PM -0500, Neil Horman wrote:
>> Hey all-
>> 	I've been working on an issue lately involving multi socket x86_64
>> systems connected via hypertransport bridges.  It appears that some systems,
>> disable the hypertransport connections during a kdump operation when all but
> the
>> crashing processor gets halted in machine_crash_shutdown.  This becomes a
>
> That would be hard to believe. Linux cannot shut down CPUs
> completely (put them back to SINIT state) because there is no generic
> interface for this and it might be impossible. They just get put 
> into a HLT loop.
>
> And even if they were in SINIT they would still need the HT connections
> otherwise it would be impossible to ever wake them up.

If forget off the top of my head.  But my memory is that if you send
the proper IPI cpus go back into SINIT.  However linux doesn't do this
currently.

> The way HT setup is normally done is that the BIOS sets it all up
> and then it never changes (except for some error conditions that 
> may cause SYNC flood) 

Yep.

> It would be better to properly root cause before applying.

Agreed.

Eric
