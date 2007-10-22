Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbXJVI53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbXJVI53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 04:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbXJVI5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 04:57:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57852 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbXJVI5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 04:57:21 -0400
Date: Mon, 22 Oct 2007 10:57:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, linux-kernel@vger.kernel.org,
       borntraeger@de.ibm.com, kvm-devel@lists.sourceforge.net
Subject: Re: [PATCH] move kvm_guest_exit() after local_irq_enable()
Message-ID: <20071022085703.GA2781@elte.hu>
References: <47135D1B.1060004@bull.net> <11927135412363-git-send-email-Laurent.Vivier@bull.net> <20071022082604.GA28528@elte.hu> <471C647A.50908@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471C647A.50908@qumranet.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> Ingo Molnar wrote:
> >* Laurent Vivier <Laurent.Vivier@bull.net> wrote:
> >
> >  
> >>According comments from Avi, we can clear PF_VCPU in kvm_guest_exit if 
> >>we move it after local_irq_enable().
> >>
> >>http://lkml.org/lkml/2007/10/15/114
> >>
> >>To simplify s390 port, we don't clear it in account_system_time().
> >>
> >>http://lkml.org/lkml/2007/10/15/183
> >>    
> >
> >thanks - i have picked your patch up.
> >
> >  
> 
> Note the kvm part is already in my 2.6.24 queue.

ok, then please push the whole patch to Linus, the scheduler bits are:

  Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
