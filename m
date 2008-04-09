Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbYDISpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbYDISpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYDISpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:45:45 -0400
Received: from colo.lackof.org ([198.49.126.79]:42084 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbYDISpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:45:44 -0400
Date: Wed, 9 Apr 2008 12:45:32 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Matti Linnanvuori <mattilinnanvuori@yahoo.com>,
       Grant Grundler <grundler@parisc-linux.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v2] doc: DMA-mapping.txt has undeclared variables [Bug
	10397]
Message-ID: <20080409184532.GG1624@colo.lackof.org>
References: <935779.51834.qm@web52004.mail.re2.yahoo.com> <200804070905.51499.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804070905.51499.jbarnes@virtuousgeek.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 09:05:51AM -0700, Jesse Barnes wrote:
> On Monday, April 07, 2008 9:01 am Matti Linnanvuori wrote:
> > From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
> >
> > Fix undeclared variables in code examples.
> > Consistently use pdev as the variable of type struct pci_dev *.
> > Bug 10397.
> 
> I think Grant's comment still stands, "fix undeclared variables" isn't an 
> accurate description of what you're doing here...

Yes, please just drop the first sentence. The second sentence is sufficient.

> That said, the patch itself looks fine to me, if a bit pedantic.  The compiler 
> will catch any mismatched arguments in this case, and the rest of the 
> documentation is pretty clear that these routines take struct pci_dev not 
> struct device, so I'd be inclined to just leave it the way it is to avoid 
> churn.

I think it's a good habit to use "pdev" in device drivers and would
like the documentation to incorporate that.

I'm ok with the churn since it's not conflicting with anything else AFAIK.

thanks,
grant

