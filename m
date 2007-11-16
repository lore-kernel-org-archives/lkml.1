Return-Path: <linux-kernel-owner+w=401wt.eu-S1763728AbXKPCvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763728AbXKPCvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbXKPCuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:50:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58486
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754932AbXKPCuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:50:51 -0500
Date: Thu, 15 Nov 2007 18:50:51 -0800 (PST)
Message-Id: <20071115.185051.159765071.davem@davemloft.net>
To: clameter@sgi.com
Cc: corbet@lwn.net, andi@firstfloor.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711151816170.31691@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711151045060.28051@schroedinger.engr.sgi.com>
	<20071115.140305.137877909.davem@davemloft.net>
	<Pine.LNX.4.64.0711151816170.31691@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 15 Nov 2007 18:19:37 -0800 (PST)

> On Thu, 15 Nov 2007, David Miller wrote:
> 
> > Well, the first version of the patch set, the one I tested, did
> > require a lot of BSS space.  And that's the one they are writing
> > about.
> 
> I am running the same version that you also ran. The problem is that you 
> did not configure the stuff properly for your box and I did not include a 
> configuration for sparc64 since I did not know how it needed to be 
> configured for sparc64. You ignored the patch for sparc64 that I provided 
> to correct the problem.

If you're talking about the VMEMMAP thing, that patch didn't remove
the problem, it simply added optimizations for sparc64 so that you could
sweep the problem under the rug.

Sparc32 is still broken, as just one of several possible examples.
The BSS usage is still there for platforms that don't use VMEMMAP.

So again, the lwn.net report is accurate.
