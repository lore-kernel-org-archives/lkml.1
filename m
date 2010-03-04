Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab0CDLyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 06:54:52 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:53364 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab0CDLyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 06:54:51 -0500
X-IronPort-AV: E=Sophos;i="4.49,580,1262563200"; 
   d="scan'208";a="9778560"
Date: Thu, 4 Mar 2010 11:58:35 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Sheng Yang <sheng@linux.intel.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 5/7] xen: Make event channel work with PV
 extension of HVM
In-Reply-To: <201003041337.26229.sheng@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1003041155590.24752@kaball-desktop>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <1267436315-24486-6-git-send-email-sheng@linux.intel.com> <4B8C6C0D.3070005@goop.org> <201003041337.26229.sheng@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, Sheng Yang wrote:
> On Tuesday 02 March 2010 09:38:21 Jeremy Fitzhardinge wrote:
> > On 03/01/2010 01:38 AM, Sheng Yang wrote:
> > > +
> > > +		x86_platform.calibrate_tsc = xen_tsc_khz;
> > > +		x86_platform.get_wallclock = xen_get_wallclock;
> > > +		x86_platform.set_wallclock = xen_set_wallclock;
> > > +
> > > +		pv_apic_ops = xen_apic_ops;
> > > +#ifdef CONFIG_X86_LOCAL_APIC
> > > +		/*
> > > +		 * set up the basic apic ops.
> > > +		 */
> > > +		set_xen_basic_apic_ops();
> > > +		apic->write = xen_hvm_pv_evtchn_apic_write;
> > 
> > I'd just change the xen_apic_write to remove the WARN_ON, since you
> > don't seem to care about it either.
> 
> So which code base I should make these patches against? We expect the patchset 
> can be accepted in the Linux upstream soon after you pick it up.

I think that once we agree on which approach we take we should work
together on this.

Jeremy, can we have our own temporary branch so that we can work
together on a common code base to finish this patch series?

