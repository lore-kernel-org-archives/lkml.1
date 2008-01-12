Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbYALXqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbYALXqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 18:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYALXqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 18:46:13 -0500
Received: from mga06.intel.com ([134.134.136.21]:59261 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751010AbYALXqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 18:46:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,276,1196668800"; 
   d="scan'208";a="322599041"
Message-ID: <47895021.5090306@linux.intel.com>
Date: Sat, 12 Jan 2008 15:41:21 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew.Morton@hera.kernel.org
Subject: Re: Top 10 kernel oopses for the week ending January 12th, 2008
References: <47890B65.80804@linux.intel.com> <20080112222322.GE17276@does.not.exist> <47894999.8060505@linux.intel.com> <20080112233355.GF17276@does.not.exist>
In-Reply-To: <20080112233355.GF17276@does.not.exist>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Jan 12, 2008 at 03:13:29PM -0800, Arjan van de Ven wrote:
>> Adrian Bunk wrote:
>>> All the other reports only contain the plain trace. Is there any way to 
>>> get more information whether the former is a pattern or not, and to
>>> get this information somehow displayed on the webpage?
>> IF the kernel prints that its tainted or whatever it'll be shown, as well
>> as the exact versions etc etc if they are there.
>> Sadly none of this information is there prior to 2.6.24-rc4.
>> ...
> 
> OK, the problem might actually not be the omission of displaying the 
> tainted information but the omission of considering any relevant 
> context.
> 
> Looking deeper:
> 
> Number #2424 is WARN_ON-after-tainted-oops.
> 
> Is your rank 1 just a symptom that the system is in a bad state after 
> running in what is your rank 8?
> 
> In this case the information when following e.g. #2827 is quite useless 
> since wherever you got this trace from all related context information 
> like e.g. whether it's like #2424 just the symptom of a previous Oops is 
> not displayed.

the tainted flags have a flag for "there was a previous oops", and if that's set,
the kerneloops.org website ignores the report. Simple as that.

> In the worst case, an entry might only contain WARN_ON traces without 
> any information where the traces came from and whether it's worth 
> looking at them or whether the system always already was in a known-bad 
> state when they occured?

again as of 2.6.24-rc4 or so, this is just no longer the case. The problem is with
older kernels which had a WARN_ON() that didn't print ANY information other than
a plain backtrace.
