Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbXLEVp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbXLEVp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 16:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXLEVpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 16:45:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35473 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbXLEVpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 16:45:12 -0500
Subject: Re: Possible bug from kernel 2.6.22 and above
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jie Chen <chen@jlab.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Simon Holm Th??gersen <odie@cs.aau.dk>
In-Reply-To: <4744966C.900@jlab.org>
References: <4744966C.900@jlab.org>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 21:36:42 +0100
Message-Id: <1196887002.6353.19.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-21 at 15:34 -0500, Jie Chen wrote:

> It is clearly that the synchronization overhead increases as the number 
> of threads increases in the kernel 2.6.21. But the synchronization 
> overhead actually decreases as the number of threads increases in the 
> kernel 2.6.23.8 (We observed the same behavior on kernel 2.6.22 as 
> well). This certainly is not a correct behavior. The kernels are 
> configured with CONFIG_SMP, CONFIG_NUMA, CONFIG_SCHED_MC, 
> CONFIG_PREEMPT_NONE, CONFIG_DISCONTIGMEM set. The complete kernel 
> configuration file is in the attachment of this e-mail.
> 
>  From what we have read, there was a new scheduler (CFS) appeared from 
> 2.6.22. We are not sure whether the above behavior is caused by the new 
> scheduler.

If I read this correctly, you say that: .22 is the first bad one right?

The new scheduler (CFS) was introduced in .23, so it seems another
change would be responsible for this.



