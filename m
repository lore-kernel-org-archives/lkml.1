Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbYHUOVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbYHUOVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbYHUOU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:20:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:50758 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbYHUOUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:20:55 -0400
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, davem@davemloft.net
Message-Id: <C72E63F0-AF40-46F4-B910-59EE9AADC5B0@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20080821234935.33de917e.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] math-emu: Fix compiler warnings
Date: Thu, 21 Aug 2008 09:20:26 -0500
References: <1219323021-7273-1-git-send-email-galak@kernel.crashing.org> <20080821234935.33de917e.sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 21, 2008, at 8:49 AM, Stephen Rothwell wrote:

> Hi Kumar,
>
> On Thu, 21 Aug 2008 07:50:20 -0500 Kumar Gala <galak@kernel.crashing.org 
> > wrote:
>>
>> Fix warnings of the form:
>> arch/powerpc/math-emu/fsubs.c:15: warning: 'R_f1' may be used  
>> uninitialized in this function
>> arch/powerpc/math-emu/fsubs.c:15: warning: 'R_f0' may be used  
>> uninitialized in this function
>>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>> ---
>>
>> I intend these patches to go via the powerpc.git tree if no one has  
>> issues.
>>
>> - k
>>
>> include/math-emu/op-2.h |    2 +-
>
> Are you modifying the right file here?  There is also
> arch/powerpc/math-emu/op-2.h which contains the same construct.

I forgot to mention this is a precursor to moving arch/powerpc to  
using the generic math-emu code in include/math-emu/

I don't see any reason to fixup the old code.

- k
