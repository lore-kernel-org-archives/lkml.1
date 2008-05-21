Return-Path: <linux-kernel-owner+w=401wt.eu-S1765996AbYEUIGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765996AbYEUIGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763856AbYEUIFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:05:18 -0400
Received: from mail37.messagelabs.com ([216.82.244.163]:53335 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763309AbYEUIFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:05:13 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-14.tower-37.messagelabs.com!1211357111!1237924!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Wed, 21 May 2008 10:05:03 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
       "Hans J. Koch" <hjk@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <gregkh@suse.de>, <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 00/03][RFC] Reusable UIO Platform Driver
Message-ID: <20080521080503.GA28751@digi.com>
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se> <20080520210713.GE3220@local> <aec7e5c30805202031x62b3b463lfde0b9e7eb32d35@mail.gmail.com> <20080521064938.GA11580@digi.com> <20080521074950.GA27310@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080521074950.GA27310@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 21 May 2008 08:05:04.0193 (UTC) FILETIME=[6028EB10:01C8BB19]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Wed, May 21, 2008 at 08:49:38AM +0200, Uwe Kleine-K?nig wrote:
> > Magnus Damm wrote:
> > >         Extending uio_pdrv driver with a chunk of physically
> > > contiguous memory isn't a big deal though.
> > I wonder how you use that memory.  Isn't it just some kind of shared
> > memory?  If so, why not use normal shared memory?  Do you really need
> > that?
> > 
> Physically contiguous memory is a real requirement, especially for DMA.
> I'm not sure what's confusing about that?
I got that, yes.  The problem is I don't see how you can use it for DMA.
The physical address is stored in info->mem[$last].internal_addr and if
there is a way to access that variable from user space, I don't see it
and would appretiate a hint.  Sorry for not expressing my concern more
clear at the first go.  I hope it's understandable now.

@Magnus: Maybe you can provide the userspace part of the driver?
How is that mapping used there?

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
