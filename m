Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbYARKyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbYARKyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYARKys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:54:48 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:41682 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750962AbYARKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:54:48 -0500
Date: Fri, 18 Jan 2008 16:24:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc8-mm1 Kernel oops will running kernbench
Message-ID: <20080118105441.GA12009@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	Andy Whitcroft <apw@shadowen.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <479064F0.7040305@linux.vnet.ibm.com> <20080118004416.6a757169.akpm@linux-foundation.org> <18320.27372.202771.764301@cargo.ozlabs.ibm.com> <479072BC.3080908@linux.vnet.ibm.com> <18320.32464.634534.415458@cargo.ozlabs.ibm.com> <479082F0.2040109@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <479082F0.2040109@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> [2008-01-18 16:14:00]:

> Paul Mackerras wrote:
> > Kamalesh Babulal writes:
> > 
> >>>>> NIP: 0000000000004570 LR: 000000000fc42dc0 CTR: 0000000000000000
> >>>>> REGS: c00000077b6bf8c0 TRAP: 0300   Not tainted  (2.6.24-rc8-mm1-autotest)
> >>>>> MSR: 8000000000001000 <ME>  CR: 28022422  XER: 00000000
> >>>>> DAR: c00000077b6bfce0, DSISR: 000000000a000000
> > 
> > Actually, how much RAM does this machine have?  If it has less than
> > 32GB, then the problem is that the kernel stack pointer is bogus.
> > (How it got to be bogus is the interesting question, of course. :)
> > 
> > Paul.
> > 
> Hi Paul,
> 
> The machine has around 30GB of RAM, do you want me to try, by taking 
> the git-powerpc.patch out of the series and try reproducing the oops.
>

Kamalesh, I thought I saw Paul's request for trying without
git-powerpc.patch (it's in a separate email). 

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
