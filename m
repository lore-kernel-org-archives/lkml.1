Return-Path: <linux-kernel-owner+w=401wt.eu-S1423219AbXBUWlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423219AbXBUWlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423227AbXBUWlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:41:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423220AbXBUWlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:41:47 -0500
Message-ID: <45DCCA05.3030903@redhat.com>
Date: Wed, 21 Feb 2007 17:39:01 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com> <20070221114737.a09be761.akpm@linux-foundation.org> <20070221222042.GG12472@bingen.suse.de>
In-Reply-To: <20070221222042.GG12472@bingen.suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>> What is the status of:
>>>
>>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-simplfy-__assign_irq_vector.patch
>>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-handle-irqs-pending-in-irr-during-irq-migration.patch
>> That's mainly an Andi decision.  Let's cc him.
> 
> I didn't think the problem was serious enough for a backport. Do we have
> user reports? 

Yes, lots:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=225399

> It's certainly not trivial obvious patches. 
