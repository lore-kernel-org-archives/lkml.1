Return-Path: <linux-kernel-owner+w=401wt.eu-S1763248AbYEHOg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763248AbYEHOg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYEHOgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:36:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:34567 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbYEHOgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:36:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,455,1204531200"; 
   d="scan'208";a="325919040"
Date: Thu, 8 May 2008 07:43:01 -0700
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, jbarnes@virtuousgeek.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: intel-iommu: CONFIG_DMAR*=y kills my box
Message-ID: <20080508144301.GA19589@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <48133A64.7020702@googlemail.com> <4813660E.8080609@googlemail.com> <20080429002901.GC31157@linux.intel.com> <481677D3.5070800@googlemail.com> <20080429225348.GA1672@linux.intel.com> <4817A98D.8080007@googlemail.com> <20080506131554.4adb3f9c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506131554.4adb3f9c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 01:15:54PM -0700, Andrew Morton wrote:
> On Wed, 30 Apr 2008 01:04:45 +0200
> Gabriel C <nix.or.die@googlemail.com> wrote:
> >
> 
> Guys, it's really painful having to scroll through thousand-line emails to
> find a few lines of information.  Please trim stuff.
> 
> > 
> > > 
> > > I do find it quite odd that a DMA code path specific to PCIE is somehow
> > > in the loop for a parallel port device.  Should this be possible?
> > 
> > I have no idea =) ( PCI folks added to CC )
> > 
> > > 
> > > I could easily be wrong so feel free to correct me but;
> > > I think your bios is goofy / unprepared to support IOMMU / VT-d and
> > > doing strange things with enumerated a parallel port on a PCIE bus with
> > > VTD is turned on...
> > 
> > I will contact ASUS peoples about the BIOS but it has for sure VT-d support and it is enabled.
> 
> So..  what happened here?  It seems like a pretty fatal problem, and
> personally I don't think that contacting vendors about BIOS upgrades is a
> suitable general solution.  It would be much better to find a kernel-based
> fix or workaround?
>

I just got some expert advice on this issue.  I will try again and look
for a problem with the iommu code getting executed before the USB / PCI
bus is fully initialized.

also, I just realized that I was attempting to reproduce the failure on
the MM tree, and re-reading the report I see its on the linux-next tree.

I'm retesting it this am.

--mgross

 
