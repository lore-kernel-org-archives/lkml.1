Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZJAWYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZJAWYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZJAWYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:24:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753357AbZJAWYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:24:38 -0400
Date: Thu, 1 Oct 2009 15:24:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Miller <davem@davemloft.net>
cc: eric.dumazet@gmail.com, jgunthorpe@obsidianresearch.com, vl@samba.org,
       opurdila@ixiacom.com, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SPLICE_F_NONBLOCK semantics...
In-Reply-To: <alpine.LFD.2.01.0910011516390.6996@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910011521550.6996@localhost.localdomain>
References: <20091001.151102.09812927.davem@davemloft.net> <alpine.LFD.2.01.0910011516390.6996@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Oct 2009, Linus Torvalds wrote:
> 
> Ack. The original intent was for the flag to affect the buffering, not the 
> end points.

Side note, in case it wasn't clear: I added Jens to the cc, because in the 
end my "original intent" probably doesn't matter all that much. I may have 
set up the basic ideas and so on, but I never wrote any apps that use it, 
and Jens has done most of the actual fixes since.

So give "my original intent" the weight (or rather, lack there-of) that it 
deserves. 

		Linus
