Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbXKTQsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbXKTQsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 11:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbXKTQsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 11:48:07 -0500
Received: from ns.suse.de ([195.135.220.2]:49780 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbXKTQsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 11:48:06 -0500
Subject: Re: [PATCH 2/3] PNP cleanups - Unify the pnp macros to
	access	resources in the pnp resource table
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>, akpm <akpm@linux-foundation.org>,
       ALSA devel <alsa-devel@alsa-project.org>
In-Reply-To: <4742EFBE.6030407@keyaccess.nl>
References: <1195552283.23700.166.camel@queen.suse.de>
	 <20071120123102.03bdaa67@the-village.bc.nu>
	 <1195568360.23700.202.camel@queen.suse.de>  <4742EFBE.6030407@keyaccess.nl>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Tue, 20 Nov 2007 17:48:04 +0100
Message-Id: <1195577284.23700.211.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-20 at 15:31 +0100, Rene Herman wrote:
> On 20-11-07 15:19, Thomas Renninger wrote:
> 
> > At the end is some example code how things could get even more cleaned
> > up. It shows how I think pnp layer and one example driver would get
> > adjusted. There are not that much drivers making use of
> > pnp_resource_change...
> 
> The ALSA ISA-PnP drivers do in what I personally consider a bad layering 
> violation. Brought up not doing that a while ago on alsa-devel, but no 
> discussion ensued. If the PnP maintainer(s) agree with me though, I'd be 
> more than happy to rip all of that out of ALSA.
> 
> (added alsa-devel)

The pnp_resource_change is really ugly..., these are making use of it:
sound/isa/sb/es968.c
sound/isa/sb/sb16.c
sound/isa/gus/interwave.c
sound/isa/es18xx.c
sound/isa/cs423x/cs4236.c
sound/isa/wavefront/wavefront.c
sound/isa/ad1816a/ad1816a.c
sound/isa/cmi8330.c
sound/isa/opl3sa2.c
sound/isa/opti9xx/opti92x-ad1848.c
sound/isa/als100.c
sound/isa/azt2320.c
sound/isa/dt019x.c


   Thomas

