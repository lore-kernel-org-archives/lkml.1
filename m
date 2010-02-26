Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966608Ab0BZXn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 18:43:57 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:60226 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966595Ab0BZXn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 18:43:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=maL9/JSctNpTRbMtlHHm/rF0DrI5+l8Ugl0ZRBdMZCuFhrs6JrNegHBNcQTx4w2cxdTW8SXKnsWEIklKKfl/x6L2AvdGpOCvQ2ggSlX7u4pyhugQrS8t9XnQfibR8wH2;
Date: Fri, 26 Feb 2010 15:44:25 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: John Linn <John.Linn@xilinx.com>
Cc: <linux-kernel@vger.kernel.org>, <devicetree-discuss@ozlabs.org>,
       <linuxppc-dev@ozlabs.org>, <microblaze-uclinux@itee.uq.edu.au>,
       <grant.likely@secretlab.ca>,
       "John Williams" <john.williams@petalogix.com>,
       <michal.simek@petalogix.com>, <benh@kernel.crashing.org>
Subject: Re: Proposal to move PCI out of arch/powerpc and into drivers/of
Message-ID: <20100226154425.00dde291@jbarnes-piketon>
In-Reply-To: <27bab769-0788-4b48-96a7-ced65e40144c@SG2EHSMHS007.ehs.local>
References: <27bab769-0788-4b48-96a7-ced65e40144c@SG2EHSMHS007.ehs.local>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 16:07:59 -0700
John Linn <John.Linn@xilinx.com> wrote:

> Hi all,
> 
> We are in the process of putting PCI/PCIe into the microblaze
> architecture.  
> 
> In order to not duplicate/fork the PCI code in Powerpc, we're
> proposing to move the PCI code from arch/powerpc into drivers/of such
> that it would be common code for Powerpc and MicroBlaze.
> 
> This would be the 1st part of a refactoring that would occur with the
> PCI code.
> 
> Ben H., would you mind if that happened (move arch/powerpc/kernel/pci*
> to drivers/of/*)?

Dave and Ben have been talking about this for awhile; seems like a good
excuse to do it.  IIRC they had even thought about just dumping the
code directly into drivers/pci so that API updates won't get missed...

-- 
Jesse Barnes, Intel Open Source Technology Center
