Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYFIU5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYFIU5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYFIU5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:57:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:50814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbYFIU5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:57:39 -0400
Date: Mon, 9 Jun 2008 22:57:34 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Amul Shah <amul.shah@unisys.com>, Andi Kleen <andi@firstfloor.org>,
       Johannes Weiner <hannes@saeurebad.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, anderson@redhat.com,
       "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Subject: Re: [patch 2/3] Add flags parameter to reserve_bootmem_generic()
Message-ID: <20080609225734.2bb9ee64@kopernikus.site>
In-Reply-To: <20080609205429.GJ3542@redhat.com>
References: <20080608134628.757299158@halley.suse.de>
	<20080608134629.743220278@halley.suse.de>
	<87bq2bmvro.fsf@saeurebad.de>
	<20080609132207.GC3542@redhat.com>
	<20080609182341.00d6e746@halley.suse.de>
	<484D5CCB.5020709@firstfloor.org>
	<1213041041.19111.68.camel@ustr-shaha1-linux-dev.na.uis.unisys.com>
	<20080609221732.1e14e5d5@kopernikus.site>
	<20080609202935.GI3542@redhat.com>
	<20080609224211.2ef0f74c@kopernikus.site>
	<20080609205429.GJ3542@redhat.com>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@redhat.com> [2008-06-09 16:54]:
>
> On Mon, Jun 09, 2008 at 10:42:11PM +0200, Bernhard Walle wrote:
> > Hi Vivek,
> > 
> > * Vivek Goyal <vgoyal@redhat.com> [2008-06-09 16:29]:
> > >
> > > Can you please put some more explanation comment here to explain that
> > > why it is ok to return with success, despite the fact that we never
> > > reserved any memory.
> > 
> > Do you think that's ok?
> > 
> >     When booting the kdump kernel, the MP tables (for example,
> >     or other firmware-reserved memory) of the BIOS are beyond
> >     end_pfn. (kexec-tools adds exactmap parameters to the kernel
> >     so that the E820 map is no longer used.) Therefore, it's ok
> >     to return "success" here. For normal boot, the MP tables
> >     must be reserved normally.
> > 
> 
> Looks good. Thanks

Should I resend the whole patch series to Linus for inclusion?



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Maintenance
