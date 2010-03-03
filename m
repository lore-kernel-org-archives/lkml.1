Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0CCRiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:38:11 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:63723 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab0CCRiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:38:09 -0500
X-IronPort-AV: E=Sophos;i="4.49,574,1262563200"; 
   d="scan'208";a="9766529"
Date: Wed, 3 Mar 2010 17:41:55 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/7] xen/hvm: Xen PV extension of  HVM
 initialization
In-Reply-To: <4B8E9DD7.6020408@goop.org>
Message-ID: <alpine.DEB.2.00.1003031741080.4648@kaball-desktop>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>  <1267436315-24486-4-git-send-email-sheng@linux.intel.com>  <4B8C63B0.2090507@goop.org>  <201003020938.53630.sheng@linux.intel.com> <1267521735.11737.23107.camel@zakaz.uk.xensource.com>
 <4B8D7248.5070807@goop.org> <alpine.DEB.2.00.1003031132550.4648@kaball-desktop> <4B8E9DD7.6020408@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, Jeremy Fitzhardinge wrote:
> On 03/03/2010 03:35 AM, Stefano Stabellini wrote:
> > Give a look at the fourth patch of the series I just posted: it
> > introduces a simple driver for the Xen PCI platform device to initialize
> > xenbus and gran table later on when running in a HVM domain, at the same
> > time leaving the PV case as it is.
> >    
> 
> Yes, I noticed that.  Do the PV drivers cope with having the PCI 
> probe/xenbus setup after their init functions have been called, or do 
> you make sure the PCI probe happens early?
> 

Nope, they seem to cope fine so far.

