Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbZBLLsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbZBLLsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbZBLLs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:48:28 -0500
Received: from [202.81.31.146] ([202.81.31.146]:33257 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbZBLLs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:48:27 -0500
X-Greylist: delayed 1186 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Feb 2009 06:48:27 EST
Message-ID: <499407E5.1070705@in.ibm.com>
Date: Thu, 12 Feb 2009 16:58:37 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: next Feb 10: mm/slqb build break
References: <20090210194121.80256b72.sfr@canb.auug.org.au> <49914790.6050008@in.ibm.com> <49914EE7.7030205@in.ibm.com> <84144f020902100353x4074f342ne4d61483074a06b7@mail.gmail.com> <20090212014503.GD30043@wotan.suse.de>
In-Reply-To: <20090212014503.GD30043@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>> Actually, that's not the root cause here. You seem to have CONFIG_SMP
>> disabled but CONFIG_NUMA enabled. That's not possible on x86 which
>> makes me think it's a ppc kconfig bug. Hmm?
>>     
>
> If it is really a valid config, then we should be able to make
> slqb build with it...
I am not sure if this is a valid config. According to arch/powerpc/Kconfig
NUMA depends on PPC64 and defaults to y if SMP & PPC_PSERIES is set.

If this is not a valid config then may be the make randconfig rules
need to be changed accordingly.

Ben should know. Ben ??

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

