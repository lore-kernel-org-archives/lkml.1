Return-Path: <linux-kernel-owner+w=401wt.eu-S933900AbZGQOdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900AbZGQOdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 10:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbZGQOdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 10:33:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:37561 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751609AbZGQOdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:33:49 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18PDlh7ZhIP5sz0grNgBhMMYBkQJ1w0rZn3EpTa5o
	IEcSIWQkX+4PXE
Date: Fri, 17 Jul 2009 16:34:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Ian Molton <ian@mnementh.co.uk>, linux-kernel@vger.kernel.org,
       Pierre Ossman <drzeus@drzeus.cx>, Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] MMC: Make the configuration memory resource optional
In-Reply-To: <aec7e5c30907170719re0b4152y987d30f8cdeb0cba@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0907171626330.4731@axis700.grange>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
 <aec7e5c30907170719re0b4152y987d30f8cdeb0cba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(forgot the "[PATCH]" marker on submission, re-added now)

On Fri, 17 Jul 2009, Magnus Damm wrote:

> On Fri, Jul 17, 2009 at 8:10 PM, Guennadi
> Liakhovetski<g.liakhovetski@gmx.de> wrote:
> > Add support for tmio_mmc hardware configurations, that lack the cnf io
> > area, like SuperH SoCs. With this patch such hardware can pass a single
> > ctl io area with the platform data.
> 
> Right, this need looks familiar. =)

Your Acked-by would be appreciated:-)

> Have you tested this on any specific platform?

Yep, on migor with the sh7722 CPU.

> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > CC: Magnus Damm <damm@opensource.se>
> > ---
> > Pierre, I know you wanted to step down as a MMC maintainer (thanks for
> > your great work btw!), but since we don't have a new one yet, I'm CC-ing
> > you.
> >
> > A version of this patch has previously been submitted by Magnus Damm
> > (CCed), but it hasn't been accepted back at 2.6.29 times (about 4 months
> > ago). Now this driver extension has become much simpler, so, I think,
> > there should be no problem accepting this patch now.
> 
> Yes, this patch looks a bit simpler than what I posted earlier. Nice work.
> 
> I remember posting a series of patches for the tmio_mmc driver, but
> only the fixes were accepted at that point. Is this patch all that is
> needed to get tmio_mmc working on your platform, or are you planning
> on posting some other patches as well?

Yes, a patch, modifying drivers/mmc/host/Kconfig and migor platform code 
will be submitted later, once this patch is accepted. In fact, maybe it 
would have been better to add SUPERH to tmio_mmc's entry in Kconfig with 
this patch, or, if sh maintainer agrees, we can pull the second patch over 
MMC tree (if / when there is one) too, to make sure the dependency is 
satisfied.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
