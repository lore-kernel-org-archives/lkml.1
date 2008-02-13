Return-Path: <linux-kernel-owner+w=401wt.eu-S1765590AbYBMPhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765590AbYBMPhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbYBMPhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:37:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:35883 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbYBMPhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:37:42 -0500
Cc: linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Message-Id: <3DBA85C8-9096-48B0-9771-D381E507909E@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Jon Loeliger <jdl@jdl.com>
In-Reply-To: <E1JPIT1-0001ke-GR@jdl.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH] [POWERPC] Fix initial lmb add region with a non-zero base 
Date: Wed, 13 Feb 2008 09:37:19 -0600
References: <Pine.LNX.4.64.0802130719330.14428@blarg.am.freescale.net>  <E1JPIT1-0001ke-GR@jdl.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 13, 2008, at 8:20 AM, Jon Loeliger wrote:

> So, like, the other day Kumar Gala mumbled:
>> If we add to an empty lmb region with a non-zero base we will not  
>> coalesce
>> the number of regions done to one.  This causes problems on ppc32  
>> for the
>
> s/done/down

will fix.

>> memory region as its assumed to only have one region.
>>
>> We can fix this be easily specially casing the initial add to just  
>> replace
>> the dummy region.
>>
>> ---
>>
>> Posting this since Dave's looking a pulling the lmb code out into  
>> lib/ and
>> sharing it between powerpc and sparc.
>
> Did you want to S-o-b: this patch?  Or was this just informational?

this was info/for review, the git tree has a s-o-b.

- k
