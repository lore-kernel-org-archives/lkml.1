Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbZFPVGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbZFPVGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761820AbZFPVFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:05:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762992AbZFPVFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:05:47 -0400
Message-ID: <4A380767.6080304@zytor.com>
Date: Tue, 16 Jun 2009 13:58:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 00/22] HWPOISON: Intro (v5)
References: <20090615024520.786814520@intel.com> <4A35BD7A.9070208@linux.vnet.ibm.com> <20090615042753.GA20788@localhost> <Pine.LNX.4.64.0906151341160.25162@sister.anvils> <20090615140019.4e405d37@lxorguk.ukuu.org.uk> <20090615132934.GE31969@one.firstfloor.org> <20090616194430.GA9545@sgi.com> <4A380086.7020904@zytor.com> <20090616205449.GA4858@sgi.com>
In-Reply-To: <20090616205449.GA4858@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russ Anderson wrote:
>>
>> However, the more fundamental thing is that it is always trivial to
>> promote an error to a higher severity; the opposite is not true.  As
>> such, it becomes an administrator-set policy, which is what it needs to be.
> 
> Good point.  On ia64 the recovery code is implemented as a kernel
> loadable module.  Installing the module turns on the feature.
> 
> That is handy for customer demos.  Install the module, inject a
> memory error, have an application read the bad data and get killed.
> Repeat a few times.  Then uninstall the module, inject a
> memory error, have an application read the bad data and watch
> the system panic.
> 
> Then it is the customer's choice to have it on or off.
> 

There are a number of ways to set escalation policy.  Modules isn't
necessarily the best, but it doesn't really matter what the exact
mechanism is.

	-hpa
