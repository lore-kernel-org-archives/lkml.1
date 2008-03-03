Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYCCWDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYCCWDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbYCCWDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:03:31 -0500
Received: from mga10.intel.com ([192.55.52.92]:64141 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751324AbYCCWDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:03:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,440,1199692800"; 
   d="scan'208";a="528086874"
Message-ID: <47CC74E6.60306@linux.intel.com>
Date: Mon, 03 Mar 2008 14:00:06 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <47CC451A.2060501@linux.intel.com> <alpine.LFD.1.00.0803031042230.17889@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803031042230.17889@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 3 Mar 2008, Arjan van de Ven wrote:
>> interesting observation: if I turn the macros into inlines... the difference
>> goes away.
>>
>> I'm half tempted to just do it as inline period ... any objections ?
> 
> Yes, I object. I want to understand why it would matter. If this is a 
> compiler bug, it's a really rather bad one. And if it's just some stupid 
> bug in our pmd_bad() macro, I still want to know what the problem was.
> 
> Can you compile both ways and look at what changed at the offending site 
> (which is apparently "follow_page()")?
> 
> And do you have some odd compiler version?

it's the F9 gcc, so yeah it's really new.

I'm staring at the disassembly and it's quite different but follow_page() is rather large;
trying to  make a smaller testcase now
