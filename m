Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZFKQ5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZFKQ5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbZFKQ5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:57:43 -0400
Received: from relais.videotron.ca ([24.201.245.36]:17961 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbZFKQ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:57:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 11 Jun 2009 12:57:19 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       swetland@google.com, pavel@ucw.cz, lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
In-reply-to: <87my8erb2b.fsf@deeprootsystems.com>
Message-id: <alpine.LFD.2.00.0906111249110.31536@xanadu.home>
References: <20090611111821.GK795@n2100.arm.linux.org.uk>
 <20090611.042226.28424489.davem@davemloft.net>
 <20090611114911.GL795@n2100.arm.linux.org.uk>
 <20090611.050030.169859977.davem@davemloft.net>
 <20090611123852.GM795@n2100.arm.linux.org.uk>
 <20090611135442.6b9ab315@lxorguk.ukuu.org.uk>
 <20090611131245.GN795@n2100.arm.linux.org.uk>
 <87my8erb2b.fsf@deeprootsystems.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Kevin Hilman wrote:

> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> 
> > On Thu, Jun 11, 2009 at 01:54:42PM +0100, Alan Cox wrote:
> >> Make your tree the core ARM code only, any other patches you don't
> >> accept. Aggressively push stuff out to platform code, and if people want
> >> to change core code "because our platform is different" make them extract
> >> it into the platform layer not carry it in the core bits.
> >
> > I'm all for giving this a try after this merge window is over.
> 
> Speaking as maintainer of one ARM subarch (davinci) and active
> contributor to another (OMAP), I would gladly give this a try as well.

Speaking as maintainer of a couple other ARM subarchs (Orion, Kirkwood, 
MV78xx0, ...) I would gladly accept full responsibility (and blame) for 
them as well.  I think Russell could avoid astraining to himself full 
review for every patch concerning those that I send his way, and merely 
look at the diffstat to be sure I'm not crapping onto the core ARM code.  
Linus certainly doesn't do much more than that on his end already.

It's been a couple merge windows now that RMK started accepting git pull 
requests from a couple people in addition to his patch system, and that 
has worked pretty well overall.


Nicolas
