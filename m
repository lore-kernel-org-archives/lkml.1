Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbYLHH3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbYLHH3C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 02:29:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbYLHH2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 02:28:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36251 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYLHH2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 02:28:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yves-Alexis Perez" <corsac@debian.org>
Subject: Re: [Bug #12152] Huge wakeups number from i1915
Date: Mon, 8 Dec 2008 08:28:07 +0100
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera> <20081207151203.46c01a0d@infradead.org> <1228717448.9677.3.camel@hidalgo>
In-Reply-To: <1228717448.9677.3.camel@hidalgo>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812080828.07683.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 8 of December 2008, Yves-Alexis Perez wrote:
> On dim, 2008-12-07 at 15:12 -0800, Arjan van de Ven wrote:
> > 
> > > > at least in some of the cases where this has been seen the cause
> > is
> > > > the following:
> > > > The i915 DRM driver used to do polling for completion, busy
> > > > waiting. It moved to be interrupt driven, which is usually better
> > > > for power, but it will show up as more wakeups in powertop....
> > > 
> > > IOW, this is not a regression?
> > 
> > I don't know about this specifc case (not enough information) but for
> > the case I described it's not a regression. Going to interrupt driven
> > from busy waiting is an improvement not a regression :)
> 
> Well, several thousand or more interrupts really seems like a
> regression :). But it seems that's the same thing as the “IRQ
> spinning” (there was a thread on dri-devel about that).
> 
> It seems fixed with a patch from Matthew Garrett applied to
> drm-intel/for-airlied but I don't think this has been applied to Linus
> master.

Any pointers to the patch, please?

Rafael
