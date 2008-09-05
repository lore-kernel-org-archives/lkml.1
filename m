Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYIENpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYIENpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbYIENpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:45:46 -0400
Received: from rtr.ca ([76.10.145.34]:36785 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbYIENpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:45:45 -0400
Message-ID: <48C13807.4080205@rtr.ca>
Date: Fri, 05 Sep 2008 09:45:43 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Additionally doing a min/max comparison to see that the loop is very 
> _stable_ is of course also a way to validate things, but expecting _too_ 
> much stability may be wrong too. As mentioned, SMM events can happen for 
> other reasons than emulation.
..

Not to mention that we still have the unsolved regression from when HPET
support first went in (2.6.2[01] timeframe), where machines randomly lock up
at "Switching to HPET" time during boot.  Depending upon kernel .config,
phase of the moon, and apparently SMM events.

Hopefully this will finally get fixed with this work?

Cheers

