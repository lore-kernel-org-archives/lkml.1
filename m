Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbXLLVfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbXLLVfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXLLVfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:35:24 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38074 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXLLVfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:35:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andi Kleen <ak@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ben Woodard <woodard@redhat.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       hbabu@us.ibm.com, Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <m1ve75z1v3.fsf@ebiederm.dsl.xmission.com>
	<20071211182254.GB10999@hmsreliant.think-freely.org>
	<m1ejdtysqd.fsf@ebiederm.dsl.xmission.com>
	<20071211192434.GD10999@hmsreliant.think-freely.org>
	<86802c440712111151t29acd38kf9fac8e41743f3e4@mail.gmail.com>
	<20071211205955.GF10999@hmsreliant.think-freely.org>
	<20071212142132.GC4889@bingen.suse.de>
	<20071212155515.GA29735@hmsendeavour.rdu.redhat.com>
	<20071212160722.GD4889@bingen.suse.de>
	<m1prxbu2ah.fsf@ebiederm.dsl.xmission.com>
	<20071212202215.GB29735@hmsendeavour.rdu.redhat.com>
Date: Wed, 12 Dec 2007 14:32:02 -0700
In-Reply-To: <20071212202215.GB29735@hmsendeavour.rdu.redhat.com> (Neil
	Horman's message of "Wed, 12 Dec 2007 15:22:15 -0500")
Message-ID: <m1lk7ztx9p.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

> I think this just leaves us with deciding on a mechanism for how to do
> single-application quirks.  I take Andi's point that adding a flag set to the
> quirk data structure is a fine solution, but I'm really ok with static integers
> in individual functions.  Do we have consensus on how to handle that?  I'm happy
> either way, but I'd rather have agreement on how to handle it before I post
> another iteration of this patch.  

As long as the solution is simple, small and concise I don't care.

And since what will make Andi happy seems to meet those criteria,
that should be fine.


Eric
