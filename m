Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbYBHB35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbYBHB35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 20:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbYBHB3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 20:29:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45533 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754952AbYBHB3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 20:29:48 -0500
Date: Thu, 7 Feb 2008 17:28:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com,
       npiggin@suse.de, akpm@linux-foundation.org, vegard.nossum@gmail.com,
       penberg@gmail.com
Subject: Re: [patch] block layer: kmemcheck fixes
In-Reply-To: <20080207.172246.31415231.davem@davemloft.net>
Message-ID: <alpine.LFD.1.00.0802071726120.2896@woody.linux-foundation.org>
References: <20080207103136.GG15220@kernel.dk> <20080207104901.GF16735@elte.hu> <alpine.LFD.1.00.0802070940230.2883@woody.linux-foundation.org> <20080207.172246.31415231.davem@davemloft.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Feb 2008, David Miller wrote:
> 
> Maybe cpus these days have so much store bandwith that doing
> things like the above is OK, but I doubt it :-)

I seriously doubt the same is true for the IO requests (which are 
different anyway, and tend to happen at a much lower frequency than 
high-speed networking).

I also suspect that your timings were very hardware-dependent in the first 
place (and yes, the long-term effect is likely working against that 
"optimization"), and depend a lot on just how sparse the initialization 
can to be.

		Linus
