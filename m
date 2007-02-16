Return-Path: <linux-kernel-owner+w=401wt.eu-S1751429AbXBPKQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbXBPKQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbXBPKQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:16:07 -0500
Received: from ns.suse.de ([195.135.220.2]:48408 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXBPKQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:16:05 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] i386 irq: Kill NR_IRQ_VECTORS and increase NR_IRQS
Date: Fri, 16 Feb 2007 11:15:58 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>,
       Natalie Protasevich <Natalie.Protasevich@unisys.com>,
       "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
References: <200702160015.04453.lenb@kernel.org> <m1mz3efn0q.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1mz3efn0q.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702161115.59017.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Allowing the kernel to work on big machines without complicated
> and error prone irq remapping logic.

How much memory does this use by default? If it's much there should
be at least a CONFIG_* to make it smaller.

-Andi
