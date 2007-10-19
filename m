Return-Path: <linux-kernel-owner+w=401wt.eu-S937432AbXJSUAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937432AbXJSUAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937203AbXJST67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:58:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46286 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937200AbXJST66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:58:58 -0400
Message-ID: <47190C80.8090400@garzik.org>
Date: Fri, 19 Oct 2007 15:58:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] irq-remove: core
References: <20071019075443.GA6407@havoc.gtf.org>	<20071019075508.GB6407@havoc.gtf.org>	<m1ir53gev4.fsf@ebiederm.dsl.xmission.com>	<4718F5BB.5010301@garzik.org> <m1ir52g9zg.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ir52g9zg.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeff Garzik <jeff@garzik.org> writes:
>> Do you think set_irqfunc_irq() should be called at all the callsites of
>> set_irq_regs(), or one the fix you mention is applied, do you think current
>> model is sufficient?
> 
> Good question.  At first glance I think the call sites are ok, that
> is where we have the information now.  Non-genirq architectures needs
> work of course.
> 
> However given the weird poll case etc that either we need to take this
> slow and delay this change until all of the drivers are fixed up, to
> not need an irq parameter (as you suggested).  Or that we need to 
> allow both forms of irq handler to coexist temporarily.

After diving in, in the past couple of hours, I'm pretty confident we 
simply do not need {get,set}_irqfunc_irq()

	Jeff



