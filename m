Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYCPKnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYCPKnV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 06:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYCPKnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 06:43:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:49303 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYCPKnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 06:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ojtAlzw0tT07aTinw4MSkGJeil3RY3H9/K3RF6oIYPFeEj4ePWIqnN0TEUGS2SftPFr6o65F6Lrk92kvihpJ4bFau9nlt8LwYuZfAR1bZ+OChSe2nTB4p789fXWaU1I6ZvY3aHYbWTdtFN1VwahhsW+tSbe41U/hNDQUw0S/SH4=
Date: Sun, 16 Mar 2008 11:42:11 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Allan Menezes <amenezes007@sympatico.ca>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: HPL benchmarking linux kernel for shared memory performance.
Message-ID: <20080316104157.GA6220@joi>
References: <47DCB26B.20907@sympatico.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DCB26B.20907@sympatico.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2008 at 01:38:51AM -0400, Allan Menezes wrote:
> Hi,
>    I eliminated in which kernel verion this begins to happen. I am 
> benchmarking a single node with hpl and openmpi beta 1.3 and gotoblas v1.24
> for personal noncommercial reasons.
> I tried a single node with the command $ mpirun -np 1 ./xhpl
> and with kernel ver 2.6.23.14 i get over 38Gflops
> but with kernel ver 2.6.23.15 compiling with the same .config i get 7.xx 
> Gflops which is 1/5th that of the other kernel.
> Keep in mind that only the kernels have changed from kernel.org not any 
> hardware or anything else as all else is same! but the  performace drops to 
> 1/5th
> There is no network involved in this single node quad core intel test but 
> just shared memory.
> So the shared memory or smp performance of the newer kernels is far far 
> worse than upto 2.6.23.14!
> Even with 2.6.25.rc5 the performance is degraded!
> Can you please help me find why this is occurring? Please advise!
> mY set up Quad core Q6600 intel overclocked stably to 2.88 GHZ , 6 gig ddr2 
> 800 mhz dual channel ram,
> Allan Menezes

If you want to speed up bug resolution, you can bisect it to only one patch with git
(google for git bisect) on this tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git

ps: please post your .config and dmesg output

Marcin
