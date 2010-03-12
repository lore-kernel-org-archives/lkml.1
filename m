Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab0CLBVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 20:21:52 -0500
Received: from mga06.intel.com ([134.134.136.21]:39839 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754780Ab0CLBVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 20:21:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,623,1262592000"; 
   d="scan'208";a="500011053"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 7/7] xen: Enable event channel of PV extension of HVM
Date: Fri, 12 Mar 2010 09:23:22 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Konrad Rzeszutek Wilk <kliw@darnok.org>
References: <1268032732-8025-1-git-send-email-sheng@linux.intel.com> <201003110934.51408.sheng@linux.intel.com> <alpine.DEB.2.00.1003111139390.11570@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1003111139390.11570@kaball-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003120923.22666.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 March 2010 19:43:00 Stefano Stabellini wrote:
> On Thu, 11 Mar 2010, Sheng Yang wrote:
> > On Wednesday 10 March 2010 23:29:30 Stefano Stabellini wrote:
> > > On Wed, 10 Mar 2010, Sheng Yang wrote:
> > > > I think we can leave the controversial thing later. At least, we want
> > > > a framework for PV extension of HVM. We can work together to
> > > > determine what is the better way for evtchn, as well as porting
> > > > pirqs. (And the later MSI work may also depends on it)
> > >
> > > Most of my patch series can be upstreamed right now, the only thing
> > > that needs some extra work is the pirq remapping.
> > > So yes, we can upstream the rest and that would also make PV on HVM
> > > work on linux upstream ASAP.
> > > I think that is a worthy goal by itself, therefore I am going to send
> > > another reduced patch series, ready to be upstreamed, without pirq
> > > remappings, with support for PV on HVM.
> >
> > I think my first 6 patches can be used without modification. And I've
> > already spent lots of efforts on them with Jeremy.
> >
> > We can work on evtchn and platform pci later.
> 
> Agreed on evtchn but platform pci should be present even in the basic
> version.
> Please read the series "basic PV on HVM support" I posted yesterday
> because I believe has already everything needed to be accepted upstream
> right now; at the same time it introduces the pv clocksource and the
> vector based callback mechanism that is going to be needed for the
> interrupt remapping we are going to work on later on.
> 
IIRC, I think your platform PCI driver also depends on evtchn to inject 
interrupt?

-- 
regards
Yang, Sheng
