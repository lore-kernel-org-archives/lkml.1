Return-Path: <linux-kernel-owner+w=401wt.eu-S1946426AbXBCKB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946426AbXBCKB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 05:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946429AbXBCKB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 05:01:26 -0500
Received: from mail.suse.de ([195.135.220.2]:46313 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946426AbXBCKB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 05:01:26 -0500
From: Andi Kleen <ak@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq migration.
Date: Sat, 3 Feb 2007 11:01:22 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       "Luigi Genoni" <luigi.genoni@pirelli.com>, Ingo Molnar <mingo@elte.hu>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200701221116.13154.luigi.genoni@pirelli.com> <m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com> <m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702031101.22313.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Once the migration operation is complete we know we will receive
> no more interrupts on this vector so the irq pending state for
> this irq will no longer be updated.  If the irq is not pending and
> we are in the intermediate state we immediately free the vector,
> otherwise in we free the vector in do_IRQ when the pending irq
> arrives.

Ok for me, although the magic numbers are a little nasty.

What about i386?

-Andi
