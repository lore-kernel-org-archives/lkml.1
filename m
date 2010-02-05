Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0BELJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 06:09:34 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:7281 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0BELJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 06:09:32 -0500
X-SpamScore: -10
X-BigFish: VPS-10(z2d9boz1432R98dN4015Lzz1202hzzz32i87h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KXD7WB-02-3N6-02
X-M-MSG: 
Date: Fri, 5 Feb 2010 12:00:11 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Avi Kivity <avi@redhat.com>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 04/11 v2] VT-d: Change {un}map_range functions to
 implement {un}map interface
Message-ID: <20100205110011.GY16236@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
 <1264678682-30655-5-git-send-email-joerg.roedel@amd.com>
 <1264712382.9059.1109.camel@macbook.infradead.org>
 <20100129090526.GT17809@8bytes.org>
 <20100201141646.GC16236@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100201141646.GC16236@amd.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 05 Feb 2010 11:00:12.0063 (UTC) FILETIME=[638462F0:01CAA652]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, Feb 01, 2010 at 03:16:46PM +0100, Joerg Roedel wrote:
> On Fri, Jan 29, 2010 at 10:05:26AM +0100, Joerg Roedel wrote:
> > > Um, that's not a page-size based interface. Page size isn't always 4KiB;
> > > this code runs on IA64 too.
> > > 
> > > We have enough fun with CPU vs. DMA page size on IA64 already :)
> > 
> > Ah right. So this should be
> > 
> > 	size     = PAGE_SIZE << gfp_order;
> > 
> > Right? The interface is meant to map the same amount of memory which
> > alloc_pages(gfp_order) would return. Same for the return value of the
> > unmap function.
> 
> Ok, here is an updated patch (also updated in the iommu/largepage
> branch). Does it look ok to you David?

have you had a chance to look at the new version of the patch? If you
are fine with it and with the overall concept of this patchset I would
be cool if you could give your Acks. I would like to send this code to
Linus in the next merge window.

Thanks,

	Joerg


