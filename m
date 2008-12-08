Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYLHNAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYLHNAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYLHM7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 07:59:51 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60406 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYLHM7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 07:59:51 -0500
Date: Mon, 8 Dec 2008 12:59:38 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yves-Alexis Perez <corsac@debian.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12152] Huge wakeups number from i1915
Message-ID: <20081208125938.GB31976@srcf.ucam.org>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera> <20081207151203.46c01a0d@infradead.org> <1228717448.9677.3.camel@hidalgo> <200812080828.07683.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200812080828.07683.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 08:28:07AM +0100, Rafael J. Wysocki wrote:
> On Monday, 8 of December 2008, Yves-Alexis Perez wrote:
> > On dim, 2008-12-07 at 15:12 -0800, Arjan van de Ven wrote:
> > > 
> > > > > at least in some of the cases where this has been seen the cause
> > > is
> > > > > the following:
> > > > > The i915 DRM driver used to do polling for completion, busy
> > > > > waiting. It moved to be interrupt driven, which is usually better
> > > > > for power, but it will show up as more wakeups in powertop....
> > > > 
> > > > IOW, this is not a regression?
> > > 
> > > I don't know about this specifc case (not enough information) but for
> > > the case I described it's not a regression. Going to interrupt driven
> > > from busy waiting is an improvement not a regression :)
> > 
> > Well, several thousand or more interrupts really seems like a
> > regression :). But it seems that's the same thing as the “IRQ
> > spinning” (there was a thread on dri-devel about that).
> > 
> > It seems fixed with a patch from Matthew Garrett applied to
> > drm-intel/for-airlied but I don't think this has been applied to Linus
> > master.
> 
> Any pointers to the patch, please?

Doesn't ring any bells for me...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
