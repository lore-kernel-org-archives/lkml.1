Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbZAJXd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbZAJXd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZAJXdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:33:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:45367 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZAJXdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:33:17 -0500
Subject: Re: [PATCH RFC v5] net: add PCINet driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ira Snyder <iws@ovro.caltech.edu>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, shemminger@vyatta.com, arnd@arndb.de,
       netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20090108215127.GA28935@ovro.caltech.edu>
References: <20090107195052.GA24981@ovro.caltech.edu>
	 <20090108.111610.132149837.davem@davemloft.net>
	 <20090108192716.GA19863@ovro.caltech.edu>
	 <20090108215127.GA28935@ovro.caltech.edu>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 10:32:35 +1100
Message-Id: <1231630355.2142.92.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 13:51 -0800, Ira Snyder wrote:
> The guests (PowerPC computers running Linux) are PCI cards in the host
> system (an Intel Pentium3-M system). The guest computers can access all
> of the host's memory. The guests provide a 1MB (movable) window into
> their memory.
> 
> The PowerPC computers also have a DMA controller, which I've used to get
> better throughput from my driver. I have a way to create interrupts to
> both the host and guest systems.

That looks -very- similar to the PCI driver for CAB and Cell triblades
that was, I think, submitted a while ago. Arnd what's the status with
that driver ?

Cheers,
Ben.


