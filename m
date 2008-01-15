Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbYAODbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbYAODbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 22:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYAODbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 22:31:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:56601 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbYAODbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 22:31:33 -0500
Cc: Kim Phillips <kim.phillips@freescale.com>, Poonam.Aggrwal@freescale.com,
       sfr@canb.auug.org.au, rubini@vision.unipv.it,
       linux-ppcdev@ozlabs.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Michael.Barkowski@freescale.com,
       ashish.kalra@freescale.com, Rich.Cutler@freescale.com
Message-Id: <5927F7A4-D42A-40F6-AE9C-EDA34738A752@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080114131530.9d33f50a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH 0/3] UCC TDM driver for MPC83xx platforms
Date: Mon, 14 Jan 2008 21:31:13 -0600
References: <FBA61160C48B8D438F3323FEFB4EF2C259F2F6@zin33exm24.fsl.freescale.net> <FBA61160C48B8D438F3323FEFB4EF2C26E7653@zin33exm24.fsl.freescale.net> <20080114120051.3207043b.kim.phillips@freescale.com> <20080114131530.9d33f50a.akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 14, 2008, at 3:15 PM, Andrew Morton wrote:

> On Mon, 14 Jan 2008 12:00:51 -0600
> Kim Phillips <kim.phillips@freescale.com> wrote:
>
>> On Thu, 10 Jan 2008 21:41:20 -0700
>> "Aggrwal Poonam" <Poonam.Aggrwal@freescale.com> wrote:
>>
>>> Hello  All
>>>
>>> I am waiting for more feedback on the patches.
>>>
>>> If there are no objections please consider them for 2.6.25.
>>>
>> if this isn't going to go through Alessandro Rubini/misc drivers, can
>> it go through the akpm/mm tree?
>>
>
> That would work.  But it might be more appropriate to go Kumar- 
> >paulus->Linus.

I'm ok w/taking the arch/powerpc bits, but I"m a bit concerned about  
the driver itself.  I'm wondering if we need a TDM framework in the  
kernel.

I guess if Poonam could possibly describe how this driver is actually  
used that would be helpful.  I see we have 8315 with a discrete TDM  
block and I'm guessing 82xx/85xx based CPM parts of some form of TDM  
as well.

- k
