Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZHTVrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZHTVrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZHTVrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:47:12 -0400
Received: from complete.lackof.org ([198.49.126.79]:57868 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbZHTVrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:47:12 -0400
Date: Thu, 20 Aug 2009 15:47:12 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Faidon Liambotis <paravoid@debian.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       bero@arklinux.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: Work around yet another BIOS bug
Message-ID: <20090820214712.GA26360@lackof.org>
References: <bug-14003-10286@http.bugzilla.kernel.org/> <20090819142634.0fc550d1.akpm@linux-foundation.org> <1250754748.8974.17.camel@macbook.infradead.org> <1250755318.8974.26.camel@macbook.infradead.org> <2c0942db0908201229o6ba670ebqda4d7cfc72d0ece8@mail.gmail.com> <1250796740.3311.2.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250796740.3311.2.camel@macbook.infradead.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 08:32:20PM +0100, David Woodhouse wrote:
> On Thu, 2009-08-20 at 12:29 -0700, Ray Lee wrote:
> > Think about changing this to a warning that "Your IOMMU appears to be
> > disabled." All ones is, after all, the traditional hint that the
> > device is turned off.
> 
> Hints are all very well, but the BIOS provided an ACPI table explicitly
> telling us that there was an active IOMMU at this location.

Could that be to reserve address space that the "disabled" IOMMU
might still be responding to?

Ie the BIOS hides the control registers so the OS won't talk to the
device but the IOMMU might still attempt to lookup certain address ranges.

I'm more inclined to believe it's sloppiness on the part of the BIOS
writers but thought this might be an alternative explanation.

thanks,
grant
