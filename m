Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYJCQZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYJCQZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYJCQZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:25:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbYJCQZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:25:30 -0400
Date: Fri, 3 Oct 2008 09:23:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [regression] Latest git has WARN_ON storm with e1000e driver
In-Reply-To: <alpine.LFD.2.00.0810030901170.3185@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0810030923340.3208@nehalem.linux-foundation.org>
References: <200810031041.49350.borntraeger@de.ibm.com> <200810031720.53923.borntraeger@de.ibm.com> <alpine.LFD.2.00.0810030825190.3262@nehalem.linux-foundation.org> <200810031755.55931.borntraeger@de.ibm.com>
 <alpine.LFD.2.00.0810030901170.3185@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Oct 2008, Linus Torvalds wrote:
> 
> So this whole bug is actually because that debug test is just _broken_. It 
> shouldn't be WARN_ON(preempt_count()), it should be 'might_sleep()', which 
> does it right.

Tested and confirmed. Committed and pushed out,

		Linus
