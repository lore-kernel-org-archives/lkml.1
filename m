Return-Path: <linux-kernel-owner+w=401wt.eu-S1762934AbYA3RUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762934AbYA3RUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbYA3RU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:20:27 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:43479 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYA3RU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:20:26 -0500
Message-ID: <47A0AE4E.5090400@linux.vnet.ibm.com>
Date: Wed, 30 Jan 2008 22:35:18 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.24-git6 soft lockup detected while running libhugetlbfs
References: <47A01C30.7020309@linux.vnet.ibm.com> <20080130165947.GA6336@elte.hu>
In-Reply-To: <20080130165947.GA6336@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
>> Softlockup is detected while running libhugetlbfs on the 2.6.24-git6 
>> kernel. The machine is a Pentium III (Cascades) 16 cpu machine.
>>
>> BUG: soft lockup - CPU#13 stuck for 61s! [swapper:0]
> 
> is nohz enabled? And the system did not truly lock up, right?
> 
> 	Ingo
> --
Hi Ingo,

The CONFIG_NO_HZ is not set and the system seems not be truly locked up
,btw wc -l of the softlockup messages is around 108 times, while running
the libhugetlbfs only and this is reproducible with the 2.6.24-git7 also.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
