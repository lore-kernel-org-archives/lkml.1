Return-Path: <linux-kernel-owner+w=401wt.eu-S1760932AbXKPDRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932AbXKPDRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbXKPDRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:17:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51270
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751548AbXKPDRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:17:12 -0500
Date: Thu, 15 Nov 2007 19:17:11 -0800 (PST)
Message-Id: <20071115.191711.44685807.davem@davemloft.net>
To: clameter@sgi.com
Cc: corbet@lwn.net, andi@firstfloor.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711151902130.322@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711151851420.32046@schroedinger.engr.sgi.com>
	<20071115.185854.85318344.davem@davemloft.net>
	<Pine.LNX.4.64.0711151902130.322@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 15 Nov 2007 19:10:15 -0800 (PST)

> On Thu, 15 Nov 2007, David Miller wrote:
> 
> > > I have not looked at sparc32 sorry. If you simply set up a couple of 
> > > configuration values in arch/sparc32/Kconfig then everything will be fine.
> > 
> > There is assembler code to write, which as I stated several
> > times nobody is going to work on or test.
> 
> There is no assembly code required. I overdid it in the patch that I sent 
> you trying to make sparc64 use large mappings like x86_64 NUMA. You really 
> do not need that. Look at the IA64 and i386 configurations. There is no C 
> code required. The x86_64 code only adds some special C code for the NUMA 
> case.

Ok, and like I said last time, I'll examine this more closely
when you spin your next version of these patches.

Please post them soon as I'm eager to test this stuff out for
you.

Thanks.
