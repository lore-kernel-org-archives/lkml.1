Return-Path: <linux-kernel-owner+w=401wt.eu-S1946429AbXBCK0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946429AbXBCK0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 05:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946431AbXBCK0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 05:26:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:47231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946429AbXBCK0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 05:26:05 -0500
From: Andi Kleen <ak@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq migration.
Date: Sat, 3 Feb 2007 11:26:01 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       "Luigi Genoni" <luigi.genoni@pirelli.com>, Ingo Molnar <mingo@elte.hu>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200701221116.13154.luigi.genoni@pirelli.com> <200702031101.22313.ak@suse.de> <m1wt2z1qxi.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1wt2z1qxi.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702031126.01483.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 February 2007 11:22, Eric W. Biederman wrote:
> Andi Kleen <ak@suse.de> writes:
> 
> >> Once the migration operation is complete we know we will receive
> >> no more interrupts on this vector so the irq pending state for
> >> this irq will no longer be updated.  If the irq is not pending and
> >> we are in the intermediate state we immediately free the vector,
> >> otherwise in we free the vector in do_IRQ when the pending irq
> >> arrives.
> >
> > Ok for me, although the magic numbers are a little nasty.
> 
> You must be talking about (vector/32) *0x10.

No I meant the -1s

-Andi
