Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030995Ab0B1AdV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 19:33:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:55430 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030972Ab0B1AdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 19:33:20 -0500
Subject: Re: Proposal to move PCI out of arch/powerpc and into drivers/of
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: John Linn <John.Linn@xilinx.com>, linux-kernel@vger.kernel.org,
       devicetree-discuss@ozlabs.org, linuxppc-dev@ozlabs.org,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       John Williams <john.williams@petalogix.com>, michal.simek@petalogix.com
In-Reply-To: <20100226154425.00dde291@jbarnes-piketon>
References: <27bab769-0788-4b48-96a7-ced65e40144c@SG2EHSMHS007.ehs.local>
	 <20100226154425.00dde291@jbarnes-piketon>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Feb 2010 11:33:06 +1100
Message-ID: <1267317186.23523.1860.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 15:44 -0800, Jesse Barnes wrote:
> 
> Dave and Ben have been talking about this for awhile; seems like a
> good
> excuse to do it.  IIRC they had even thought about just dumping the
> code directly into drivers/pci so that API updates won't get
> missed... 

Depends which part. Not -all- of our PCI code as John seems to want.

The bits that generate PCI devices from the device-tree, for sure,
though again, even there, there are quite a few dependencies on
constructs and data structures that are powerpc specific, or even ppc64
specific in some cases, and that would have to be cleaned up and/or
abstracted first.

Cheers,
Ben.


