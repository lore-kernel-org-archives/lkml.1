Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbYIBGQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbYIBGQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 02:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYIBGQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 02:16:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49567 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbYIBGQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 02:16:19 -0400
Date: Tue, 2 Sep 2008 08:19:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, David Woodhouse <dwmw2@infradead.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Misc fixes for 2.6.27
Message-ID: <20080902061920.GK18288@one.firstfloor.org>
References: <1220300084.2982.139.camel@pmac.infradead.org> <87wshvwl8v.fsf@basil.nowhere.org> <20080901153517.2f8b1ef8@infradead.org> <87sksjwjwg.fsf@basil.nowhere.org> <20080901161639.5215db63@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901161639.5215db63@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 04:16:39PM -0700, Arjan van de Ven wrote:
> On Tue, 02 Sep 2008 01:01:19 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Arjan van de Ven <arjan@infradead.org> writes:
> > 
> > > On Tue, 02 Sep 2008 00:32:16 +0200
> > > Andi Kleen <andi@firstfloor.org> wrote:
> > >
> > >> David Woodhouse <dwmw2@infradead.org> writes:
> > >> > +
> > >> > +static struct dmi_system_id __initdata intel_iommu_dmi_table[]
> > >> > = {
> > >> > +	{	/* Some DG33BU BIOS revisions advertised
> > >> > non-existent VT-d */
> > >> 
> > >> Are you sure it's non existent? A G33 chipset should have it in
> > >> hardware I thought.
> > >
> > > nope they don't/
> > > later ones and some other models do though, but not the G33
> > 
> > I see. But presumably that chipset will be in other motherboards
> > too and that BIOS bug might be also wider spread. So it would be
> > still better to key off an PCI-ID or similar.
> > 
> 
> it would be nice, no doubt, unfortunately this code runs (and needs to
> run) before the PCI subsystem is initialized...

early quirks handles these cases. Check out early-quirks.c

-Andi

-- 
ak@linux.intel.com
