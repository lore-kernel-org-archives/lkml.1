Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbXLSWEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbXLSWEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 17:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXLSWEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 17:04:23 -0500
Received: from mail.tmr.com ([64.65.253.246]:55996 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbXLSWEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 17:04:22 -0500
Message-ID: <476999B7.1000203@tmr.com>
Date: Wed, 19 Dec 2007 17:22:47 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 00/29] Swap over NFS -v15
References: <20071214153907.770251000@chello.nl>
In-Reply-To: <20071214153907.770251000@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Hi,
> 
> Another posting of the full swap over NFS series. 
> 
> Andrew/Linus, could we start thinking of sticking this in -mm?
> 

Two questions:
1 - what is the memory use impact on the system which don't do swap over 
NFS, such as embedded systems, and
2 - what is the advantage of this code over the two existing network 
swap approaches, swapping to NFS mounted file and swap to NBD device?

I've used the NFS file when a program was running out of memory and that 
seemed to work, people in UNYUUG have reported that the nbd swap works, 
so what's better here?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
