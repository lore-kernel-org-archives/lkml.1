Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbYDWR6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbYDWR6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 13:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYDWR6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:58:30 -0400
Received: from outbound-mail-37.bluehost.com ([69.89.20.191]:40425 "HELO
	outbound-mail-37.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753103AbYDWR63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:58:29 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [patch v2] doc: DMA-mapping.txt has undeclared variables [Bug 10397]
Date: Wed, 23 Apr 2008 10:58:19 -0700
User-Agent: KMail/1.9.9
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Matti Linnanvuori <mattilinnanvuori@yahoo.com>,
       linux-kernel@vger.kernel.org
References: <935779.51834.qm@web52004.mail.re2.yahoo.com> <200804070905.51499.jbarnes@virtuousgeek.org> <20080409184532.GG1624@colo.lackof.org>
In-Reply-To: <20080409184532.GG1624@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804231058.20005.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.210.190 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 09, 2008 11:45 am Grant Grundler wrote:
> On Mon, Apr 07, 2008 at 09:05:51AM -0700, Jesse Barnes wrote:
> > On Monday, April 07, 2008 9:01 am Matti Linnanvuori wrote:
> > > From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
> > >
> > > Fix undeclared variables in code examples.
> > > Consistently use pdev as the variable of type struct pci_dev *.
> > > Bug 10397.
> >
> > I think Grant's comment still stands, "fix undeclared variables" isn't an
> > accurate description of what you're doing here...
>
> Yes, please just drop the first sentence. The second sentence is
> sufficient.
>
> > That said, the patch itself looks fine to me, if a bit pedantic.  The
> > compiler will catch any mismatched arguments in this case, and the rest
> > of the documentation is pretty clear that these routines take struct
> > pci_dev not struct device, so I'd be inclined to just leave it the way it
> > is to avoid churn.
>
> I think it's a good habit to use "pdev" in device drivers and would
> like the documentation to incorporate that.
>
> I'm ok with the churn since it's not conflicting with anything else AFAIK.

Matti, can you post an update with Grant's comments addressed?  It's mainly 
about the changelog comment at this point, which should read something 
like "Update DMA mapping documentation to use 'pdev' rather than 'dev' in 
example code that calls routines expecting 'struct pci_device *', since 'dev' 
might make readers think they're passing 'struct device *' parameters."

Assuming it looks ok I'll go ahead and put it into the PCI tree.

Thanks,
Jesse

