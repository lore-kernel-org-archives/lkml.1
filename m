Return-Path: <linux-kernel-owner+w=401wt.eu-S1423467AbXBPJXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423467AbXBPJXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423465AbXBPJXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:23:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41696 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423455AbXBPJXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:23:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Natalie Protasevich <Natalie.Protasevich@unisys.com>
Cc: Len Brown <lenb@kernel.org>, Andi Kleen <ak@suse.de>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] i386: irq: Kill IRQ compression
References: <200702160015.04453.lenb@kernel.org>
	<m1wt2ih7i0.fsf@ebiederm.dsl.xmission.com>
Date: Fri, 16 Feb 2007 02:21:56 -0700
In-Reply-To: <m1wt2ih7i0.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Fri, 16 Feb 2007 00:44:07 -0700")
Message-ID: <m18xeyh2yz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> By itself I don't think we are going to observe any real problems
> with this patch.
>
> However if we are going to be serious about this we need to do a
> few more things.
>
> - kill ioapic_renumber_irq.

Looking closer ioapic_renumber_irq does not appear to be an irq
compress thing.  Rather it appears to be a work around for a weird
acpi implementation where gsi 0 - 15 are not the ISA irqs. 

Natalie is my reading of the code there correct?

If so keeping ioapic_renumber_irq makes sense.  Although giving
it a name that suggests it is working around weird implementation
details would be good.

Eric
