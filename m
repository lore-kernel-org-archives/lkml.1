Return-Path: <linux-kernel-owner+w=401wt.eu-S933626AbZJOQfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbZJOQfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933392AbZJOQfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:35:23 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:38645 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381AbZJOQfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:35:22 -0400
Message-ID: <4AD74ED7.9070501@s5r6.in-berlin.de>
Date: Thu, 15 Oct 2009 18:33:27 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: david@lang.hm
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <gregkh@suse.de>
Subject: Re: removing existing working drivers via staging
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> I missed this discussion in the thread "Moving drivers into 
> staging (was Re: [GIT PULL] SCSI fixes for 2.6.32-" and I suspect that 
> many others did as well
> 
> for those that missed it, as I understand it the proposal is that 'ugly' 
> (working drivers that don't do things the kernel way and are perceived as 
> not being commonly used anymore) drivers will get moved into staging, and

There was mention of "abandoned and unused" drivers (rather than "not
/commonly/ used anymore"), see e.g.
http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-10/msg05204.html
(2nd to last paragraph; thread continues with Greg's follow-up).

> if the driver maintainers do not clean them up within 6-9 months they will 
> be removed entirely.
> 
> the expectation is that if there are no maintainers for the driver who 
> care enough to do the cleanup they should be removed (with interested 
> users being able to take over maintaining the drivers if there the 
> maintainers are MIA)
> 
> I have several reactions to this
> 
> I think that 6-9 months (2-3 releases) is _far_ too short for users to 
> notice. most users will be using a distro kernel that is on a release 
> cycle longer than this (even if they are not using a 'enterprise' distro), 
> so their first inkling of a problem will be the driver disappearing on 
> them. Yes the driver can be recovered through git, bit at that point 
> there is going to be catch-up changes to make.
> 
> What happened to the desire that Linux would be able to use anything, and 
> once a driver was upstream changes to the kernel that would break it 
> should be fixed by whoever is introducing those changes? This seems to be 
> moving in the direction of only having drivers for fairly current, fairly 
> common hardware.

AFAIU, mostly just code which is known to _not work_ anymore or has been
functionally replaced by an alternative drops out of the mainline.  This
idea of using drivers/staging/ in the process is surely not going to
change that in principle; it will only raise awareness among active
kernel developers better than feature-removal-schedule.txt can do.
-- 
Stefan Richter
-=====-==--= =-=- -====
http://arcgraph.de/sr/
