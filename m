Return-Path: <linux-kernel-owner+w=401wt.eu-S932669AbXKPC70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbXKPC70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762981AbXKPC64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:58:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55714
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761756AbXKPC6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:58:55 -0500
Date: Thu, 15 Nov 2007 18:58:54 -0800 (PST)
Message-Id: <20071115.185854.85318344.davem@davemloft.net>
To: clameter@sgi.com
Cc: corbet@lwn.net, andi@firstfloor.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711151851420.32046@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711151816170.31691@schroedinger.engr.sgi.com>
	<20071115.185051.159765071.davem@davemloft.net>
	<Pine.LNX.4.64.0711151851420.32046@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 15 Nov 2007 18:55:21 -0800 (PST)

> On Thu, 15 Nov 2007, David Miller wrote:
> 
> > Sparc32 is still broken, as just one of several possible examples.
> 
> I have not looked at sparc32 sorry. If you simply set up a couple of 
> configuration values in arch/sparc32/Kconfig then everything will be fine.

There is assembler code to write, which as I stated several
times nobody is going to work on or test.

It is unreasonable to add this new VMEMMAP requirement in order for
your patches to work properly.

> > The BSS usage is still there for platforms that don't use VMEMMAP.
> 
> All MMU platforms can use the virtual mappings. The main use of the static 
> configuration is for embedded systems.

Someone has to implement and test VMEMMAP now on all of these
architectures, it is becomming a requirement unlike in the sparsemem
patches case where it was optional.

That's unreasonable.
