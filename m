Return-Path: <linux-kernel-owner+w=401wt.eu-S967137AbXJSXN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967137AbXJSXN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 19:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759366AbXJSXNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 19:13:50 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36487 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347AbXJSXNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 19:13:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] irq-remove: core
References: <20071019075443.GA6407@havoc.gtf.org>
	<20071019075508.GB6407@havoc.gtf.org>
	<m1ir53gev4.fsf@ebiederm.dsl.xmission.com>
	<4718F5BB.5010301@garzik.org>
	<m1ir52g9zg.fsf@ebiederm.dsl.xmission.com>
	<47190C80.8090400@garzik.org>
Date: Fri, 19 Oct 2007 17:13:35 -0600
In-Reply-To: <47190C80.8090400@garzik.org> (Jeff Garzik's message of "Fri, 19
	Oct 2007 15:58:56 -0400")
Message-ID: <m1hckmem00.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Eric W. Biederman wrote:
>> Jeff Garzik <jeff@garzik.org> writes:
>>> Do you think set_irqfunc_irq() should be called at all the callsites of
>>> set_irq_regs(), or one the fix you mention is applied, do you think current
>>> model is sufficient?
>>
>> Good question.  At first glance I think the call sites are ok, that
>> is where we have the information now.  Non-genirq architectures needs
>> work of course.
>>
>> However given the weird poll case etc that either we need to take this
>> slow and delay this change until all of the drivers are fixed up, to
>> not need an irq parameter (as you suggested).  Or that we need to allow both
>> forms of irq handler to coexist temporarily.
>
> After diving in, in the past couple of hours, I'm pretty confident we simply do
> not need {get,set}_irqfunc_irq()

Sounds good.  That was my impression when I was looking at this kind of stuff.

Just so long as this doesn't slow us down so much we don't actually drop the
ball on this.

Eric
