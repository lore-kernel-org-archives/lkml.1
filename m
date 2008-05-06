Return-Path: <linux-kernel-owner+w=401wt.eu-S1764351AbYEFUQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764351AbYEFUQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYEFUQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:16:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202AbYEFUQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:16:27 -0400
Date: Tue, 6 May 2008 13:15:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: mgross@linux.intel.com, linux-kernel@vger.kernel.org, ashok.raj@intel.com,
       shaohua.li@intel.com, anil.s.keshavamurthy@intel.com,
       jbarnes@virtuousgeek.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: intel-iommu: CONFIG_DMAR*=y kills my box
Message-Id: <20080506131554.4adb3f9c.akpm@linux-foundation.org>
In-Reply-To: <4817A98D.8080007@googlemail.com>
References: <48133A64.7020702@googlemail.com>
	<4813660E.8080609@googlemail.com>
	<20080429002901.GC31157@linux.intel.com>
	<481677D3.5070800@googlemail.com>
	<20080429225348.GA1672@linux.intel.com>
	<4817A98D.8080007@googlemail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 01:04:45 +0200
Gabriel C <nix.or.die@googlemail.com> wrote:
>

Guys, it's really painful having to scroll through thousand-line emails to
find a few lines of information.  Please trim stuff.

> 
> > 
> > I do find it quite odd that a DMA code path specific to PCIE is somehow
> > in the loop for a parallel port device.  Should this be possible?
> 
> I have no idea =) ( PCI folks added to CC )
> 
> > 
> > I could easily be wrong so feel free to correct me but;
> > I think your bios is goofy / unprepared to support IOMMU / VT-d and
> > doing strange things with enumerated a parallel port on a PCIE bus with
> > VTD is turned on...
> 
> I will contact ASUS peoples about the BIOS but it has for sure VT-d support and it is enabled.

So..  what happened here?  It seems like a pretty fatal problem, and
personally I don't think that contacting vendors about BIOS upgrades is a
suitable general solution.  It would be much better to find a kernel-based
fix or workaround?


