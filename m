Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966606Ab0BZXu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 18:50:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:40003 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab0BZXuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 18:50:54 -0500
Subject: Re: Proposal to move PCI out of arch/powerpc and into drivers/of
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <27bab769-0788-4b48-96a7-ced65e40144c@SG2EHSMHS007.ehs.local>
Date: Fri, 26 Feb 2010 17:50:26 -0600
Cc: <linux-kernel@vger.kernel.org>, <devicetree-discuss@ozlabs.org>,
       <linuxppc-dev@ozlabs.org>, <microblaze-uclinux@itee.uq.edu.au>,
       michal.simek@petalogix.com, John Williams <john.williams@petalogix.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <CDF924F6-56F9-4F3D-9CF9-BF321437C3B5@kernel.crashing.org>
References: <27bab769-0788-4b48-96a7-ced65e40144c@SG2EHSMHS007.ehs.local>
To: John Linn <John.Linn@xilinx.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 26, 2010, at 5:07 PM, John Linn wrote:

> Hi all,
> 
> We are in the process of putting PCI/PCIe into the microblaze
> architecture.  
> 
> In order to not duplicate/fork the PCI code in Powerpc, we're proposing
> to move the PCI code from arch/powerpc into drivers/of such that it
> would be common code for Powerpc and MicroBlaze.
> 
> This would be the 1st part of a refactoring that would occur with the
> PCI code.
> 
> Ben H., would you mind if that happened (move arch/powerpc/kernel/pci*
> to drivers/of/*)?
> 
> Thanks,
> John

John,

Does MicroBlaze firmware produce full OF style PCI device tree's or do what we do on embedded systems and just have the root and leave the probing to the kernel?  I haven't looked at the OF side of what we do in PPC in a while but I know we have some major differences between PPC32 & PPC64 because of assumptions about what the firmware provides (or doesnt).

As well as features on the PPC64 side to not re-probe PCI and build internal kernel data structures purely from the OF tree.

I think moving the code and sharing it between everyone is a good thing, just point out some issues I know we are aware of.

- k