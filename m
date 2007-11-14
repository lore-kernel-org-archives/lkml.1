Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbXKNBaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbXKNBaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXKNBaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:30:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33841
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbXKNBaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:30:10 -0500
Date: Tue, 13 Nov 2007 17:30:09 -0800 (PST)
Message-Id: <20071113.173009.247667472.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711131339240.3714@schroedinger.engr.sgi.com>
References: <20071106195157.878563669@sgi.com>
	<20071113.031510.151440585.davem@davemloft.net>
	<Pine.LNX.4.64.0711131339240.3714@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Tue, 13 Nov 2007 13:40:19 -0800 (PST)

> On Tue, 13 Nov 2007, David Miller wrote:
> 
> > One thing you could do is simply use a vmalloc allocation in the
> > non-virtualized case.
> 
> Yuck. Meaning to add more crappy code. The bss limitations to 8M is a bit 
> strange though. Do other platforms have the same issues? 

sparc32 has the same limit.

I'm surprised this is your reaction instead of "oh damn, sorry
I bloated up the kernel image size by 8mb, I'll find a way to
fix that."
