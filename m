Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYIAXUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYIAXUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYIAXQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:16:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:45077 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbYIAXQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:16:44 -0400
Date: Mon, 1 Sep 2008 16:16:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Woodhouse <dwmw2@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Misc fixes for 2.6.27
Message-ID: <20080901161639.5215db63@infradead.org>
In-Reply-To: <87sksjwjwg.fsf@basil.nowhere.org>
References: <1220300084.2982.139.camel@pmac.infradead.org>
	<87wshvwl8v.fsf@basil.nowhere.org>
	<20080901153517.2f8b1ef8@infradead.org>
	<87sksjwjwg.fsf@basil.nowhere.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2008 01:01:19 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > On Tue, 02 Sep 2008 00:32:16 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> >
> >> David Woodhouse <dwmw2@infradead.org> writes:
> >> > +
> >> > +static struct dmi_system_id __initdata intel_iommu_dmi_table[]
> >> > = {
> >> > +	{	/* Some DG33BU BIOS revisions advertised
> >> > non-existent VT-d */
> >> 
> >> Are you sure it's non existent? A G33 chipset should have it in
> >> hardware I thought.
> >
> > nope they don't/
> > later ones and some other models do though, but not the G33
> 
> I see. But presumably that chipset will be in other motherboards
> too and that BIOS bug might be also wider spread. So it would be
> still better to key off an PCI-ID or similar.
> 

it would be nice, no doubt, unfortunately this code runs (and needs to
run) before the PCI subsystem is initialized...

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
