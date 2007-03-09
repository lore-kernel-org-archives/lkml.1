Return-Path: <linux-kernel-owner+w=401wt.eu-S2992908AbXCICws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992908AbXCICws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 21:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992909AbXCICws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 21:52:48 -0500
Received: from ozlabs.org ([203.10.76.45]:44642 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992908AbXCICwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 21:52:47 -0500
Date: Thu, 8 Mar 2007 20:52:32 -0600
From: Anton Blanchard <anton@samba.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
Message-ID: <20070309025232.GD24695@kryten>
References: <45ED1A3C.6030707@argo.co.il> <200703071906.58405.dada1@cosmosbay.com> <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org> <200703071952.13219.dada1@cosmosbay.com> <20070307221401.GA16938@kryten> <Pine.LNX.4.64.0703071453080.5963@woody.linux-foundation.org> <f2b55d220703071725w7c09b93bgbf357aeb25a21c2b@mail.gmail.com> <6E1C86DF-D512-418C-B270-BC5C4316BC0A@mac.com> <45EFBA14.9090307@cosmosbay.com> <8638AE87-6005-4021-98EB-43E55694B0FB@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8638AE87-6005-4021-98EB-43E55694B0FB@mac.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> Well, PowerPC "dcbt" does prefetch() correctly, it doesn't ever raise  
> exceptions, doesn't have any side effects, takes only enough CPU to  
> decode the address, and is ignored if it would have to do anything  
> other than load the cacheline from RAM.  Prefetch streams are halted  
> when they reach the end of a page boundary (no trapping to the MMU)  
> and if the TLB entry isn't present then they would asynchronously  
> abort.  

It depends on the implementation and the HID bit settings. Some do walk
the MMU hashtable if it isnt in the TLB.

Anton
