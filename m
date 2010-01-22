Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587Ab0AVKPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0AVKPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 05:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528Ab0AVKPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 05:15:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33812 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab0AVKPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 05:15:33 -0500
Message-ID: <4B597A7B.4050906@zytor.com>
Date: Fri, 22 Jan 2010 02:14:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Haicheng Li <haicheng.li@linux.intel.com>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm/srat_64.c: make node_possible_map include hotpluggable
 node
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com> <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com> <4B5731E2.4040207@linux.intel.com> <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com> <4B57C2DD.3050402@linux.intel.com> <alpine.DEB.2.00.1001202252320.22343@chino.kir.corp.google.com> <4B5802EF.6040603@linux.intel.com> <alpine.DEB.2.00.1001202344580.29982@chino.kir.corp.google.com> <4B581160.2090209@linux.intel.com> <alpine.DEB.2.00.1001211500290.31073@chino.kir.corp.google.com> <4B592437.9060508@linux.intel.com> <4B5954C6.6010102@zytor.com> <4B596539.1050207@linux.intel.com>
In-Reply-To: <4B596539.1050207@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2010 12:43 AM, Haicheng Li wrote:
> H. Peter Anvin wrote:
>> I have to say I agree with David Rientjes that we need the minimal patch
>> for upstream and stable.  If you need the additional bitmask in the
>> future it should be added later.
>>
>> Haicheng, would you be willing to prepare a minimal patch so we can
>> close the issue in the release trees as quickly as possible?
> 
> Peter,
> 
> Okay, let's close it. then please take the patch pasted below, which is
> the one without additional bitmask added.
> 

As David asked, OK to add your Tested-by: line?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

