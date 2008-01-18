Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbYARKoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbYARKoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYARKoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:44:08 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:57537 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752881AbYARKoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:44:07 -0500
Message-ID: <479082F0.2040109@linux.vnet.ibm.com>
Date: Fri, 18 Jan 2008 16:14:00 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 Kernel oops will running kernbench
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <479064F0.7040305@linux.vnet.ibm.com> <20080118004416.6a757169.akpm@linux-foundation.org> <18320.27372.202771.764301@cargo.ozlabs.ibm.com> <479072BC.3080908@linux.vnet.ibm.com> <18320.32464.634534.415458@cargo.ozlabs.ibm.com>
In-Reply-To: <18320.32464.634534.415458@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Kamalesh Babulal writes:
> 
>>>>> NIP: 0000000000004570 LR: 000000000fc42dc0 CTR: 0000000000000000
>>>>> REGS: c00000077b6bf8c0 TRAP: 0300   Not tainted  (2.6.24-rc8-mm1-autotest)
>>>>> MSR: 8000000000001000 <ME>  CR: 28022422  XER: 00000000
>>>>> DAR: c00000077b6bfce0, DSISR: 000000000a000000
> 
> Actually, how much RAM does this machine have?  If it has less than
> 32GB, then the problem is that the kernel stack pointer is bogus.
> (How it got to be bogus is the interesting question, of course. :)
> 
> Paul.
> 
Hi Paul,

The machine has around 30GB of RAM, do you want me to try, by taking 
the git-powerpc.patch out of the series and try reproducing the oops.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
