Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab0CKLi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:38:58 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:2638 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab0CKLi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:38:56 -0500
X-IronPort-AV: E=Sophos;i="4.49,619,1262563200"; 
   d="scan'208";a="9893965"
Date: Thu, 11 Mar 2010 11:43:00 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Sheng Yang <sheng@linux.intel.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Konrad Rzeszutek Wilk <kliw@darnok.org>
Subject: Re: [Xen-devel] [PATCH 7/7] xen: Enable event channel of PV extension
 of HVM
In-Reply-To: <201003110934.51408.sheng@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1003111139390.11570@kaball-desktop>
References: <1268032732-8025-1-git-send-email-sheng@linux.intel.com> <201003101056.42511.sheng@linux.intel.com> <alpine.DEB.2.00.1003101452540.28412@kaball-desktop> <201003110934.51408.sheng@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010, Sheng Yang wrote:
> On Wednesday 10 March 2010 23:29:30 Stefano Stabellini wrote:
> > On Wed, 10 Mar 2010, Sheng Yang wrote:
> > > I think we can leave the controversial thing later. At least, we want a
> > > framework for PV extension of HVM. We can work together to determine what
> > > is the better way for evtchn, as well as porting pirqs. (And the later
> > > MSI work may also depends on it)
> > 
> > Most of my patch series can be upstreamed right now, the only thing that
> > needs some extra work is the pirq remapping.
> > So yes, we can upstream the rest and that would also make PV on HVM work
> > on linux upstream ASAP.
> > I think that is a worthy goal by itself, therefore I am going to send
> > another reduced patch series, ready to be upstreamed, without pirq
> > remappings, with support for PV on HVM.
> > 
> I think my first 6 patches can be used without modification. And I've already 
> spent lots of efforts on them with Jeremy.
> 
> We can work on evtchn and platform pci later.
> 

Agreed on evtchn but platform pci should be present even in the basic
version.
Please read the series "basic PV on HVM support" I posted yesterday
because I believe has already everything needed to be accepted upstream
right now; at the same time it introduces the pv clocksource and the
vector based callback mechanism that is going to be needed for the
interrupt remapping we are going to work on later on.

