Return-Path: <linux-kernel-owner+w=401wt.eu-S937087AbXJSTxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937087AbXJSTxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbXJSTuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:50:23 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35368 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936505AbXJSTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:50:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] irq-remove: core
References: <20071019075443.GA6407@havoc.gtf.org>
	<20071019075508.GB6407@havoc.gtf.org>
	<m1ir53gev4.fsf@ebiederm.dsl.xmission.com>
	<4718F5BB.5010301@garzik.org>
Date: Fri, 19 Oct 2007 13:50:11 -0600
In-Reply-To: <4718F5BB.5010301@garzik.org> (Jeff Garzik's message of "Fri, 19
	Oct 2007 14:21:47 -0400")
Message-ID: <m1ir52g9zg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:
>
> Do you think set_irqfunc_irq() should be called at all the callsites of
> set_irq_regs(), or one the fix you mention is applied, do you think current
> model is sufficient?

Good question.  At first glance I think the call sites are ok, that
is where we have the information now.  Non-genirq architectures needs
work of course.

However given the weird poll case etc that either we need to take this
slow and delay this change until all of the drivers are fixed up, to
not need an irq parameter (as you suggested).  Or that we need to 
allow both forms of irq handler to coexist temporarily.

Eric
