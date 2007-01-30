Return-Path: <linux-kernel-owner+w=401wt.eu-S1750922AbXA3XvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750922AbXA3XvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbXA3XvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:51:10 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:36410 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbXA3XvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:51:09 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 2/4] Add support to OProfile for
	profiling Cell BE SPUs -- update
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@ozlabs.org, maynardj@us.ibm.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net
In-Reply-To: <200701300508.56467.arnd@arndb.de>
References: <45BE4ED0.5030808@us.ibm.com> <45BE4F55.8070801@us.ibm.com>
	 <200701300508.56467.arnd@arndb.de>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 15:51:05 -0800
Message-Id: <1170201065.5235.43.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd:

Well most of the patch is simply cleaning up the
pm_rtas_activate_signals() routine.  I would be think
"pm_rtas_activat_signals routine cleanup" would be good.

                   Carl Love


On Tue, 2007-01-30 at 05:08 +0100, Arnd Bergmann wrote:
> On Monday 29 January 2007 20:47, Maynard Johnson wrote:
> >   The code was setting up the debug bus for group 21 when profiling on the 
> > event PPU CYCLES.  The debug bus is not actually used by the hardware 
> > performance counters when counting PPU CYCLES.  Setting up the debug bus
> > for PPU CYCLES causes signal routing conflicts on the debug bus when 
> > profiling PPU cycles and another PPU event.  This patch fixes the code to 
> > only setup the debug bus to route the performance signals for the non
> > PPU CYCLE events.
> > 
> > Signed-off-by: Maynard Johnson <mpjohn@us.ibm.com>
> > Signed-off-by: Carl Love <carll@us.ibm.com>
> 
> Acked-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
> 
> Any suggestion for a one-line patch title?
> _______________________________________________
> cbe-oss-dev mailing list
> cbe-oss-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/cbe-oss-dev

