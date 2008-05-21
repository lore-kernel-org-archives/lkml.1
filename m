Return-Path: <linux-kernel-owner+w=401wt.eu-S1762993AbYEUJAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762993AbYEUJAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYEUJAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:00:43 -0400
Received: from mail161.messagelabs.com ([216.82.253.115]:58969 "EHLO
	mail161.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbYEUJAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:00:41 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-3.tower-161.messagelabs.com!1211360433!7930658!4
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Wed, 21 May 2008 10:50:33 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: Paul Mundt <lethal@linux-sh.org>, "Hans J. Koch" <hjk@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <gregkh@suse.de>,
       <linux-sh@vger.kernel.org>, Katsuya MATSUBARA <matsu@igel.co.jp>
Subject: Re: [PATCH 00/03][RFC] Reusable UIO Platform Driver
Message-ID: <20080521085033.GA29607@digi.com>
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se> <20080520210713.GE3220@local> <aec7e5c30805202031x62b3b463lfde0b9e7eb32d35@mail.gmail.com> <20080521064938.GA11580@digi.com> <20080521074950.GA27310@linux-sh.org> <20080521080503.GA28751@digi.com> <aec7e5c30805210122w5bdb8443r69bb7776e085276b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec7e5c30805210122w5bdb8443r69bb7776e085276b@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 21 May 2008 08:50:33.0990 (UTC) FILETIME=[BB3EE260:01C8BB1F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Magnus Damm wrote:
> On Wed, May 21, 2008 at 5:05 PM, Uwe Kleine-König
> <Uwe.Kleine-Koenig@digi.com> wrote:
> > @Magnus: Maybe you can provide the userspace part of the driver?
> > How is that mapping used there?
> 
> [Added Matsubara-san as CC]
> 
> Sure, here is a little test program. Have a look at "uio_mem". The
> "address" member contains the physical address that can be used for
> bus mastering DMA. Compare that to "iomem" which is the pointer to the
> virtual memory area in user space.
> 
> Hope this helps!
Yes it does.  I thought the physical address is stored in internal_addr
and the virtual in addr, but it's the other way round.  Thanks.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
