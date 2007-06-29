Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbXF2VSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbXF2VSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbXF2VSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:18:24 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:43206 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbXF2VSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:18:23 -0400
Date: Fri, 29 Jun 2007 17:18:15 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Robert Hancock <hancockr@shaw.ca>, Zan Lynx <zlynx@acm.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: 2.6.22-rc6-mm1 Intel DMAR crash on AMD x86_64
Message-ID: <20070629211815.GA23988@rhun.ibm.com>
References: <46845943.7050005@shaw.ca> <FC1D1B23302A22499C60C967336B2AE0016F7529@pdsmsx411.ccr.corp.intel.com> <20070629152858.GA27995@linux-os.sc.intel.com> <20070629162343.GD27698@rhun.ibm.com> <20070629192353.GA12413@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629192353.GA12413@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 12:23:53PM -0700, Keshavamurthy, Anil S wrote:

> Since this is IOMMU is built into the kernel and it is good idea to
> report that the device is not present.

Yes - as a debug message.

> The above is printed only once and is consistent with other IOMMU
> implementation. Atleast it is useful when people report bugs we can
> makeout whether IOMMU is being detected or not.

If it was printed that it was detected it was - otherwise, it wasn't.

> Here is what I see on my box.
> [..]
> "PCI-GART: No AMD northbridge found."

You're right, that should be a debug message as well.

> [..]
> Calgary: detecting Calgary via BIOS EBDA area
> Calgary: Unable to locate Rio Grande table in EBDA - bailing!

These are KERN_DEBUG messages.

Cheers,
Muli
