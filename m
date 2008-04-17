Return-Path: <linux-kernel-owner+w=401wt.eu-S1764601AbYDQLAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764601AbYDQLAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYDQLAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:00:13 -0400
Received: from oss.sgi.com ([192.48.170.157]:44249 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYDQLAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:00:12 -0400
Date: Thu, 17 Apr 2008 11:59:52 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Roel Kluin <12o3l@tiscali.nl>, linux-mips@linux-mips.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6 v2] MIPS: ip27-timer: unsigned irq to evaluate
	allocate_irqno()
Message-ID: <20080417105930.GA28713@linux-mips.org>
References: <480559DC.2060807@tiscali.nl> <20080416091554.GA6026@alpha.franken.de> <480616C6.3080203@tiscali.nl> <20080416222755.GA18832@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416222755.GA18832@alpha.franken.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 12:27:56AM +0200, Thomas Bogendoerfer wrote:

> On Wed, Apr 16, 2008 at 05:09:58PM +0200, Roel Kluin wrote:
> > Thomas Bogendoerfer wrote:
> > > On Wed, Apr 16, 2008 at 03:43:56AM +0200, Roel Kluin wrote:
> > >> irq is unsigned, cast to signed to evaluate the allocate_irqno() return value,
> >  
> > >> +		if ((int) irq < 0)
> > > 
> > > Why don't you just make irq and rt_timer_irq an int ?
> > 
> > Ok, thanks, It should be right, but I cannot test this (no hardware).
> 
> I've tested it on real hardware.
> 
> Acked-By: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Thanks, applied.

  Ralf
