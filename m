Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbYIEEpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbYIEEpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 00:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYIEEpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 00:45:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:49962 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYIEEpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 00:45:03 -0400
Date: Thu, 4 Sep 2008 21:44:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nicolas Pitre <nico@cam.org>
Cc: Dmitry Torokhov <dtor@insightbb.com>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@osdl.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH] ucb1400_ts depends SND_AC97_BUS
Message-Id: <20080904214444.0dccf859.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.1.10.0809050028590.23787@xanadu.home>
References: <20061209003635.e778ff76.randy.dunlap@oracle.com>
	<200612092150.02940.dtor@insightbb.com>
	<20061209185737.1768315d.randy.dunlap@oracle.com>
	<200612092205.19358.dtor@insightbb.com>
	<Pine.LNX.4.64.0612092212410.2630@xanadu.home>
	<20061209210945.5abe2d89.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0612102244140.2630@xanadu.home>
	<20080904195744.f367cd2d.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0809050028590.23787@xanadu.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Sep 2008 00:37:17 -0400 (EDT) Nicolas Pitre wrote:

> On Thu, 4 Sep 2008, Randy Dunlap wrote:
> 
> > On Sun, 10 Dec 2006 22:55:25 -0500 (EST) Nicolas Pitre wrote:
> > 
> > > On Sat, 9 Dec 2006, Randy Dunlap wrote:
> > > 
> > > > On Sat, 09 Dec 2006 22:17:55 -0500 (EST) Nicolas Pitre wrote:
> > > > 
> > > > > Please consider what SND_CONFIG_AC97_BUS corresponds to.  It is 
> > > > > sound/pci/ac97/ac97_bus.c and if you look into this file you'll see that 
> > > > > it is perfectly buildable even if sound is entirely configured out, just 
> > > > > like some lib code would be.
> > > > 
> > > > OK.  Should it (CONFIG_SND_AC97_BUS -> sound/pci/ac97/ac97_bus.c)
> > > > be buildable when sound is disabled?
> > > 
> > > Yes.
> > > 
> > > > If so, where should it be moved to (since afaik, make won't even
> > > > descend into sound/ if SOUND=n; I don't see that changing
> > > > any time soon).
> > > 
> > > What about this patch?
> > 
> > Can we get this patch or some patch into the input tree for linux-next?
> 
> This patch is commit e1036502e5263851259d147771226161e5ccc85a and 
> appeared in mainline almost 2 years ago.

Ack.  Sorry about that.  Wrong ucb thread.

ucb1400_core still has build errors in linux-next
since it uses ac97_bus_type even when CONFIG_SOUND=n.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
