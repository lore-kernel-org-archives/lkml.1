Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbYDKP1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbYDKP1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760026AbYDKP1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:27:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55763 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759960AbYDKP1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:27:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Date: Fri, 11 Apr 2008 17:27:32 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Jiri Kosina <jkosina@suse.cz>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> <20080411105108.GA1844@elte.hu> <20080411113746.GV10019@one.firstfloor.org>
In-Reply-To: <20080411113746.GV10019@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804111727.33922.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 of April 2008, Andi Kleen wrote:
> > thanks Pavel, i picked this up into sched-devel.git - it makes sense 
> > independently of whether it solves the warning.
> 
> This means the CPU preempt sanity checking is effectively disabled
> on UP kernels. Even though more and more people should run multi-core
> now there is still a sizeable user base left on single core.
> 
> Don't think this is a good idea. We need even the UP testers.

Agreed.

Besides, I'd like to learn what caused the problem to appear in the first
place.

> If he wants this for suspend or machine check/oops (always useful there
> to disable such warnings) then there should
> be separate checks for this. Perhaps system_state could be enhanced for this?

That would make sense.

Thanks,
Rafael
