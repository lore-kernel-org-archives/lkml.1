Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZFOJnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZFOJnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbZFOJnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:43:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:36792 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369AbZFOJnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:43:19 -0400
Subject: Re: [PATCH][BUILD FAILURE 03/04] Next June 04:PPC64 randconfig
 [drivers/net/lance.o]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: subrata@linux.vnet.ibm.com
Cc: netdev@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <1245050509.5239.11.camel@subratamodak.linux.ibm.com>
References: <20090611035046.22125.26641.sendpatchset@subratamodak.linux.ibm.com>
	 <1245048698.5239.9.camel@subratamodak.linux.ibm.com>
	 <1245049899.19217.56.camel@pasglop>
	 <1245050509.5239.11.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 19:43:01 +1000
Message-Id: <1245058981.12400.3.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 12:51 +0530, Subrata Modak wrote:
> On Mon, 2009-06-15 at 17:11 +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2009-06-15 at 12:21 +0530, Subrata Modak wrote:
> > 
> > > Benjamin,
> > > 
> > > I am not sure whether you liked the following patch to solve the above
> > > problem. Do, you want me address some other issue(s)/fixes for this ?
> > 
> > I suppose ... in fact some old PReP machines can even have ISA slots
> > iirc, but it's not going to do good with machines that have an iommu...
> > 
> > IE. Nobody should use that crap, period.
> 
> Great,
> 
> Can you please make some changes at drivers/net/Kconfig so that this guy
> does not build for the PPC64 systems ?

When I said "that crap" I was talking about those interfaces which I
-hope- are deprecated :-)

I suspect we never really sorted out the issue of DMA mapping for old
legacy ISA stuff... pci_map_* should work to some extent, though you
have to pass it the ISA bridge pci_dev.

Maybe it's time for somebody to start exposing a -proper- abstraction
accross all platforms for that :-)

Ben.


