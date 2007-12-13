Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbXLMPAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbXLMPAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbXLMPAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:00:00 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3074 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbXLMO77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:59:59 -0500
Date: Thu, 13 Dec 2007 09:23:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ingo Molnar <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, mbuesch@freenet.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
Message-ID: <20071213142302.GC3083@tuxdriver.com>
References: <20071213003028.676998182@mvista.com> <1197508801.22951.40.camel@imap.mvista.com> <20071213101327.GM8977@elte.hu> <200712131211.32899.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712131211.32899.mb@bu3sch.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 12:11:32PM +0100, Michael Buesch wrote:
> On Thursday 13 December 2007 11:13:27 Ingo Molnar wrote:
> > 
> > * Daniel Walker <dwalker@mvista.com> wrote:
> > 
> > > > This driver is scheduled for removal, so I'd not touch it anymore to 
> > > > avoid the possibility to introduce a lastminute regression. The new 
> > > > drivers (b43 and b43legacy) have this fixed (in a different way by 
> > > > completely removing it).
> > > 
> > > When is the removal scheduled?
> > 
> > $ grep -i bcm Documentation/feature-removal-schedule.txt
> > $
> > 
> > might make sense to update this file.
> 
> Patches are on their way.
> I think it's scheduled to be removed after 2.6.25 was released.

A patch w/ subject "bcm43xx: mark as obsolete and schedule for removal"
is queued in net-2.6.25 and waiting for the 2.6.25 merge window.
It includes this hunk:

--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -333,3 +333,12 @@ Why:	This driver has been marked obsolete for many years.
 Who:	Stephen Hemminger <shemminger@linux-foundation.org>
 
 ---------------------------
+
+What:	bcm43xx wireless network driver
+When:	2.6.26
+Files:	drivers/net/wireless/bcm43xx
+Why:	This driver's functionality has been replaced by the
+	mac80211-based b43 and b43legacy drivers.
+Who:	John W. Linville <linville@tuxdriver.com>
+
+---------------------------

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
