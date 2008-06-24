Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbYFXXXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbYFXXXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 19:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbYFXXXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 19:23:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:13169 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309AbYFXXXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 19:23:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,698,1204531200"; 
   d="scan'208";a="2146236"
Date: Tue, 24 Jun 2008 16:22:52 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: [Bug 10843] Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Message-ID: <20080624232252.GA24620@linux-os.sc.intel.com>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <200806142359.36613.elendil@planet.nl> <8B23168BCBB43B49A4C8EAB32D4B62F1061F3A82@orsmsx505.amr.corp.intel.com> <200806231439.00899.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806231439.00899.elendil@planet.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 05:38:59AM -0700, Frans Pop wrote:
> On Sunday 15 June 2008, Siddha, Suresh B wrote:
> > Frans Pop wrote:
> > > On Saturday 14 June 2008, Rafael J. Wysocki wrote:
> > > > Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=10843
> > > > Subject       : Display artifacts on XOrg logout with PAT kernel
> > > > and VESA framebuffer
> > > > Submitter     : Frans Pop <elendil@planet.nl>
> > > > Date          : 2008-05-31 14:04 (15 days old)
> > > > References    : http://lkml.org/lkml/2008/6/7/206
> > >
> > > Yes. See also: http://lkml.org/lkml/2008/6/13/159
> >
> > Frans, With or without pat, in the recent kernels (like 2.6.26-rc4/rc5
> > etc), ioremap() uses  UC- and PCI mmap of /sys/devices/pci.../resource
> > (used by X) uses UC-
> >
> > And fb_mmap() also uses UC-.
> >
> > It's interesting that you don't see this artifact with "nopat".
> > Essentially with or with out pat enabled, we use the same memory
> > attributes. So depending on the MTRR setup (set by X server), effective
> > memory attribute across different mappings should be same (which is UC-
> > or WC with mtrr).
> 
> Any progress on this issue? It's still there with -rc7, but I doubt that
> comes as a surprise.
> 
> Has anyone tried to reproduce this? I would think that should be trivial.
> 
> Just as a summary:
> - Intel 82945G/GZ graphics [8086:2772] (ICH7 based system)
> - FB_VESA=y, FRAMEBUFFER_CONSOLE=y
> - boot with vga=791
> - Log in to X and KDE; I do need to really log in there are no artifacts
>   if I exit X from the kdm login dialog
> - artifacts show on logout
> 
> I doubt it's KDE related or even related to my specific graphics card.
> 
> It may well be related to what is or has been displayed on the display
> before logging out, so running some apps may make sense. Seems like I do
> see remnants of for example aptitude (Debian apt frontend) after I've run
> it in an X term (KDE's konsole).

FJP, We will try to reproduce this and getback. Your earlier responses did not
give many clues.

thanks,
suresh
