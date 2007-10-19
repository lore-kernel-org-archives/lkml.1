Return-Path: <linux-kernel-owner+w=401wt.eu-S936427AbXJSS6C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936427AbXJSS6C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:58:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932240AbXJSS5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:57:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:32963 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758391AbXJSS5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:57:53 -0400
Message-ID: <4718FE2B.1030909@garzik.org>
Date: Fri, 19 Oct 2007 14:57:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/9] Remove 'irq' argument from all irq handlers
References: <20071019075443.GA6407@havoc.gtf.org>	<alpine.LFD.0.9999.0710191649120.22770@localhost.localdomain> <m1bqavgdbf.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1bqavgdbf.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Yes.  keeping this alive is good.
> 
> The practical question is how do we make this change without breaking
> the drivers that use their irq argument.


This is why I'm taking it slow, and not rushing to get this upstream :)

I am finding a ton of bugs in each get_irqfunc_irq() driver, so I would 
rather patiently sift through them, and push fixes and cleanups upstream.

Once that effort is done, everything should be in the 'trivial' pile and 
not have the logic that you are worried about (and thus there would be 
no need to add an additional branch to the error handling path).

	Jeff


