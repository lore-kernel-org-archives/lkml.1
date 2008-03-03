Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbYCCVCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbYCCVCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYCCVCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:02:45 -0500
Received: from outbound-mail-105.bluehost.com ([69.89.18.5]:41505 "HELO
	outbound-mail-105.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752028AbYCCVCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:02:44 -0500
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Mar 2008 16:02:44 EST
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: Weirdness in pci_read_bases()
Date: Mon, 3 Mar 2008 13:02:14 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: benh@kernel.crashing.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
References: <1204252667.15052.402.camel@pasglop> <1204576954.21545.10.camel@pasglop> <200803031257.33249.jbarnes@virtuousgeek.org>
In-Reply-To: <200803031257.33249.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031302.14234.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 03, 2008 12:57 pm Jesse Barnes wrote:
> > Not only iommu's. On lots of platforms, we have the PCI MMIO space
> > mapped 1:N, that is, an access at MMIO location N turns into a PCI cycle
> > with address 0. So outbound PCI is effectively remapped, thus allowing
> > access to things like 0 etc... without punching holes in RAM and without
> > other dirty x86-like tricks.
>
> Right, bus address space is really a separate entity; I was just using
> IOMMUs as an example of that...

Err, wasn't really clear here.  CPU->PCI space and PCI->host space are really 
separate entities... IOMMUs will definitely affect the PCI->host mapping, and 
CPU->PCI mappings can be arbitrarily complex as well, though as you say on 
PCs it's typically just flatly mapped into CPU physical space somewhere.

Jesse
