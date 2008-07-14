Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbYGNW0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbYGNW0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbYGNW0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:26:14 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:22165 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbYGNW0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:26:13 -0400
X-BigFish: VPS-18(z10d1kz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh87il64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K40OYN-02-2D6-01
Date: Tue, 15 Jul 2008 00:25:38 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix pci_subsys_init() to have a return value
Message-ID: <20080714222538.GO7963@erda.amd.com>
References: <20080711094636.18199.94804.stgit@warthog.procyon.org.uk> <200807141421.03305.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <200807141421.03305.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 14 Jul 2008 22:25:42.0176 (UTC) FILETIME=[8D1A5200:01C8E600]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.07.08 14:21:03, Jesse Barnes wrote:
> On Friday, July 11, 2008 2:46 am David Howells wrote:
> > Fix pci_subsys_init() to return a value (0) when it has finished.  All the
> > functions it calls currently return 0, so returning 0 here unconditionally
> > rather than gathering the results of its callees would seem reasonable.
> >
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > ---
> >
> >  arch/x86/pci/legacy.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> >
> > diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
> > index 3c1d795..00e29c8 100644
> > --- a/arch/x86/pci/legacy.c
> > +++ b/arch/x86/pci/legacy.c
> > @@ -63,5 +63,6 @@ int __init pci_subsys_init(void)
> >  	pci_legacy_init();
> >  	pcibios_irq_init();
> >  	pcibios_init();
> > +	return 0;
> >  }
> >  subsys_initcall(pci_subsys_init);
> 
> Looks like Robert already pushed a patch like this via the x86 tree, but at 
> least it's been fixed.

Right, there was also another location to fix.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

