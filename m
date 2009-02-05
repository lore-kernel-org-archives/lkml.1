Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZBEJEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZBEJEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZBEJDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:03:47 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:34099 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbZBEJDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:03:45 -0500
Date: Thu, 5 Feb 2009 02:03:43 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Subject: RE: [PATCH F 06/12] OMAP2/3 clock: every clock must have a clkdm
In-Reply-To: <13B9B4C6EF24D648824FF11BE89671620376F47DFB@dlee02.ent.ti.com>
Message-ID: <alpine.DEB.2.00.0902050201250.8567@utopia.booyaka.com>
References: <20090128193326.2396.9437.stgit@localhost.localdomain> <20090128193512.2396.75340.stgit@localhost.localdomain> <20090131140804.GH1394@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0902030011320.5741@utopia.booyaka.com>
 <13B9B4C6EF24D648824FF11BE89671620376F47DFB@dlee02.ent.ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Tue, 3 Feb 2009, Woodruff, Richard wrote:

> > Virtual clocks should soon be eliminated from the OMAP clock tree.  (
> > "Virtual clocks" is here used to refer a clock that does not have a
> > referent in the hardware; the usage of the term in the code is loose.)
> > So far as I know, all of the OMAP virtual clocks have either turned out to
> > be superfluous (and prone to spinlock recursion bugs), or to be better
> > implemented outside of the clock framework (such as the virtual OPP
> > clocks).  We've eliminated the former.  We should be able to eliminate the
> > latter in a few months.
> 
> What is your idea for replacement of virtual OPPs?
> 
> Especially on OMAP2 they were useful with tightly coupled clock sets.  
> Some later versions of 2420 were characterized such that some of the 
> dependencies could be ignored but that is not the case for all of them.  
> The centerline design as I understand it wasn't for this. It just 
> happened that enough margin was there in some binn'ed lots to do this.

The rates and voltages would still be tightly coupled; the OPP change just 
wouldn't be handled by the clock framework.  Will send patches to you once 
the code is fully baked, the patches would probably the best thing to 
comment on...


- Paul
