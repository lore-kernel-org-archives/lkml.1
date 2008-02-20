Return-Path: <linux-kernel-owner+w=401wt.eu-S1764665AbYBTDC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764665AbYBTDC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 22:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764551AbYBTDCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 22:02:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:59799 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764536AbYBTDCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 22:02:14 -0500
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Message-Id: <4130F47E-4F4A-4911-B63B-403A8C423565@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20080219.163003.152862383.davem@davemloft.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH v2][POWERPC] Fix initial lmb add region with a non-zero base
Date: Tue, 19 Feb 2008 21:02:04 -0600
References: <Pine.LNX.4.64.0802191350590.10089@blarg.am.freescale.net> <20080219.163003.152862383.davem@davemloft.net>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 19, 2008, at 6:30 PM, David Miller wrote:

> From: Kumar Gala <galak@kernel.crashing.org>
> Date: Tue, 19 Feb 2008 13:51:37 -0600 (CST)
>
>> If we add to an empty lmb region with a non-zero base we will not  
>> coalesce
>> the number of regions down to one.  This causes problems on ppc32  
>> for the
>> memory region as its assumed to only have one region.
>>
>> We can fix this easily by causing the initial add to replace the  
>> dummy
>> region.
>>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>> ---
>>
>> Fix a bug the initial patch introduced if we have a region that  
>> gets added
>> at the beginning of the list we wouldn't actually add it.
>>
>> Dave can you replace the patch in you tree with this one.
>
> I think my tree has already or will soon be pulled in so
> I don't want to rebase it.
>
> Why don't you simply send me the relative bug fix instead?

np.  Are we trying to get this into 2.6.25 or .26?

- k
