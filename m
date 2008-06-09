Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYFIVBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYFIVBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbYFIVBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:01:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbYFIVBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:01:02 -0400
Date: Mon, 9 Jun 2008 17:00:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: Amul Shah <amul.shah@unisys.com>, Andi Kleen <andi@firstfloor.org>,
       Johannes Weiner <hannes@saeurebad.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, anderson@redhat.com,
       "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Subject: Re: [patch 2/3] Add flags parameter to reserve_bootmem_generic()
Message-ID: <20080609210055.GK3542@redhat.com>
References: <87bq2bmvro.fsf@saeurebad.de> <20080609132207.GC3542@redhat.com> <20080609182341.00d6e746@halley.suse.de> <484D5CCB.5020709@firstfloor.org> <1213041041.19111.68.camel@ustr-shaha1-linux-dev.na.uis.unisys.com> <20080609221732.1e14e5d5@kopernikus.site> <20080609202935.GI3542@redhat.com> <20080609224211.2ef0f74c@kopernikus.site> <20080609205429.GJ3542@redhat.com> <20080609225734.2bb9ee64@kopernikus.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609225734.2bb9ee64@kopernikus.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 10:57:34PM +0200, Bernhard Walle wrote:
> * Vivek Goyal <vgoyal@redhat.com> [2008-06-09 16:54]:
> >
> > On Mon, Jun 09, 2008 at 10:42:11PM +0200, Bernhard Walle wrote:
> > > Hi Vivek,
> > > 
> > > * Vivek Goyal <vgoyal@redhat.com> [2008-06-09 16:29]:
> > > >
> > > > Can you please put some more explanation comment here to explain that
> > > > why it is ok to return with success, despite the fact that we never
> > > > reserved any memory.
> > > 
> > > Do you think that's ok?
> > > 
> > >     When booting the kdump kernel, the MP tables (for example,
> > >     or other firmware-reserved memory) of the BIOS are beyond
> > >     end_pfn. (kexec-tools adds exactmap parameters to the kernel
> > >     so that the E820 map is no longer used.) Therefore, it's ok
> > >     to return "success" here. For normal boot, the MP tables
> > >     must be reserved normally.
> > > 
> > 
> > Looks good. Thanks
> 
> Should I resend the whole patch series to Linus for inclusion?
> 

I am really not sure. :-). In the past, Andrew picked up the patches, kept
in his tree for couple of days and if something is important, he will push
it out to Linus.

Thanks
Vivek
