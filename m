Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0CJDVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:21:38 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:38677 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab0CJDVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:21:35 -0500
X-Greylist: delayed 692 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 22:21:35 EST
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH 7/7] xen: Enable event channel of PV extension of HVM
Date: Tue, 9 Mar 2010 22:08:22 -0500
User-Agent: KMail/1.9.10
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Konrad Rzeszutek Wilk <kliw@darnok.org>
References: <1268032732-8025-1-git-send-email-sheng@linux.intel.com> <alpine.DEB.2.00.1003090954010.4869@kaball-desktop> <4B96A0D4.60605@goop.org>
In-Reply-To: <4B96A0D4.60605@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003092208.23964.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 March 2010 14:26:12 Jeremy Fitzhardinge wrote:
> On 03/09/2010 02:22 AM, Stefano Stabellini wrote:
> > Indeed.
> > You just need the pirq mappings and few other things, it shouldn't be
> > too hard.
> > At this point I am going to do that myself after this patch series is
> > completed.

Stefano,

Take a look at 
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git 
pv/pcifront-2.6.32

It has a Linus 2.6.32 as a base and all of the patches necessary for PCI front 
to work. That includes a lot of patches in the events and the pirq/event 
channel to make it work. Also tie ins to the MSI/MSI-X and IRQ interrupts to 
have a PCI device work in PV guest.



>
> Thanks.  You might want to coordinate with Konrad who's doing the same
> thing to get pcifront into an upstreamable form; I think there would be
> some overlap.
>
>      J


