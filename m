Return-Path: <linux-kernel-owner+w=401wt.eu-S1759672AbXKPDUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672AbXKPDUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbXKPDTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:19:52 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50099 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754483AbXKPDTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:19:51 -0500
Date: Thu, 15 Nov 2007 19:19:50 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: corbet@lwn.net, andi@firstfloor.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071115.191711.44685807.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711151917430.371@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711151851420.32046@schroedinger.engr.sgi.com>
 <20071115.185854.85318344.davem@davemloft.net>
 <Pine.LNX.4.64.0711151902130.322@schroedinger.engr.sgi.com>
 <20071115.191711.44685807.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, David Miller wrote:

> > There is no assembly code required. I overdid it in the patch that I sent 
> > you trying to make sparc64 use large mappings like x86_64 NUMA. You really 
> > do not need that. Look at the IA64 and i386 configurations. There is no C 
> > code required. The x86_64 code only adds some special C code for the NUMA 
> > case.
> 
> Ok, and like I said last time, I'll examine this more closely
> when you spin your next version of these patches.

All the above statements are about the version of the patch that I 
thought you had a look at.

> Please post them soon as I'm eager to test this stuff out for
> you.

Ok. Thanks. (You could test it with the current version.... Just edit 
Kconfig and try a few things and I could include the settings in the next 
release.)


