Return-Path: <linux-kernel-owner+w=401wt.eu-S1761769AbZEMXbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761769AbZEMXbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZEMXa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 19:30:58 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:56185 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725AbZEMXa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 19:30:57 -0400
Subject: Re: [PATCH] x86: Reduce the default HZ value
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "devzero@web.de" <devzero@web.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <711906814@web.de>
References: <711906814@web.de>
Content-Type: text/plain; charset=utf-8
Organization: VMware INC.
Date: Wed, 13 May 2009 16:30:59 -0700
Message-Id: <1242257459.30122.8.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-05-12 at 12:45 -0700, devzero@web.de wrote:
> >> > As a side note Red Hat ships runtime configurable tick behaviour in RHEL
> >> > these days. HZ is fixed but the ticks can be bunched up. That was done as
> >> > a quick fix to keep stuff portable but its a lot more sensible than
> >> > randomly messing with the HZ value and its not much code either.
> >> > 
> >> Hi Alan, 
> >> 
> >> I guess you are talking about the tick_divider patch ? 
> >> And that's still same as reducing the HZ value only that it can be done
> >> dynamically (boot time), right ? 
> >
> >Yes - which has the advantage that you can select different behaviours
> >rather than distributions having to build with HZ=1000 either for
> >compatibility or responsiveness can still allow users to drop to a lower
> >HZ value if doing stuff like HPC.
> >
> >Basically it removes the need to argue about it at build time and lets
> >the user decide.
> 
> any reason why this did not reach mainline?

I think it is because during the time when this was implemented for RHEL
5, mainline was moving towards the tickless approach, which might have
prompted people to think that it would no more be useful for mainline.

Since Alan was the one who implemented those patches, I guess he would
have a better say on this. Alan, are there any plans for mainlining this
now ?

Alok
> is it because there were issues with clocksource=pit ?
> 
> regards
> roland
> 
> ______________________________________________________
> GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
> Jetzt freischalten unter http://movieflat.web.de
> 

