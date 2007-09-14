Return-Path: <linux-kernel-owner+w=401wt.eu-S1764747AbXINP3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764747AbXINP3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 11:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbXINP3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 11:29:10 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:53354 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbXINP3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 11:29:09 -0400
Date: Fri, 14 Sep 2007 19:29:13 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Message-ID: <20070914192913.A6668@jurassic.park.msu.ru>
References: <fa.ggBqx6W3i6hfs6jdfg64oXKSxW8@ifi.uio.no> <fa.o5cJ0O7pLVWRzUiVPDEZL6nKqA8@ifi.uio.no> <fa.tyYt4GOpTOmJTUbzsxpiCAObJPQ@ifi.uio.no> <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no> <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no> <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <46EA00DA.6010704@shaw.ca> <20070914151401.A5586@jurassic.park.msu.ru> <46EA9B23.7030709@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <46EA9B23.7030709@shaw.ca>; from hancockr@shaw.ca on Fri, Sep 14, 2007 at 08:30:59AM -0600
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 08:30:59AM -0600, Robert Hancock wrote:
> Do you have an example of specific hardware that exhibits this problem?

Well, first two results of google search for "disable bar when sizing":
 http://lkml.org/lkml/2002/12/21/95
 http://lkml.org/lkml/2002/12/20/110

> So far after a similar patch has been in -mm for months there have been 
> no reports of any such problems.

You cannot compare user base of -mm and release kernels. Also, note
that we're talking about maybe 0.01% of systems running Linux.
And similar patch appeared in various trees several times over the last
decade and every time it had to be reverted.

> This isn't guaranteed to help. I don't think it is only integrated 
> graphics that could cause this problem, I think that an add-on PCI 
> Express card can do this as well. Depending on the chipset memory decode 
> rules, any PCI or PCI Express device with a BAR large enough could cause 
> issues.

No, it's impossible for several reasons. Most obvious one is that a PCI-E
bridge does isolate stuff quite nicely.

Ivan.
