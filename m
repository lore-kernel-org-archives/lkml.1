Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbXJVI0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbXJVI0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 04:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXJVI00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 04:26:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45322 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbXJVI0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 04:26:25 -0400
Date: Mon, 22 Oct 2007 10:26:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: linux-kernel@vger.kernel.org, avi@qumranet.com, borntraeger@de.ibm.com,
       kvm-devel@lists.sourceforge.net
Subject: Re: [PATCH] move kvm_guest_exit() after local_irq_enable()
Message-ID: <20071022082604.GA28528@elte.hu>
References: <47135D1B.1060004@bull.net> <11927135412363-git-send-email-Laurent.Vivier@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11927135412363-git-send-email-Laurent.Vivier@bull.net>
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


* Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> According comments from Avi, we can clear PF_VCPU in kvm_guest_exit if 
> we move it after local_irq_enable().
> 
> http://lkml.org/lkml/2007/10/15/114
> 
> To simplify s390 port, we don't clear it in account_system_time().
> 
> http://lkml.org/lkml/2007/10/15/183

thanks - i have picked your patch up.

	Ingo
