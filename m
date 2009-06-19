Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbZFSBdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbZFSBdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 21:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZFSBcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 21:32:52 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:50563 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbZFSBcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 21:32:52 -0400
Subject: Re: [PULL] hardware latency detector
From: Jon Masters <jonathan@jonmasters.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jon Masters <jcm@jonmasters.org>, mingo@elte.hu, tglx@linutronix.de,
       williams@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.01.0906181824540.16802@localhost.localdomain>
References: <E1MHSnC-0006bC-OW@tonnant>
	 <alpine.LFD.2.01.0906181824540.16802@localhost.localdomain>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Thu, 18 Jun 2009 21:32:20 -0400
Message-Id: <1245375140.14766.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 18:25 -0700, Linus Torvalds wrote:
> 
> On Thu, 18 Jun 2009, Jon Masters wrote:
> > 
> > Please pull "hwlat", the hardware latency detector for 2.6.31.
> 
> I really want to know more before I pull.

Ok.

> Has this been in -next?

No, it hasn't. But it has been tested quite extensively by a number of
people and is currently in the -rt tree.

> Discussed on lkml?

Yes. I posted an RFC patch back when it was called the SMI detector,
then a patch last week with the new generic name of hardware latency
detector (at Ingo's suggestion of renaming).

> How does it work?

It started as an SMI detector. Basically, when this module is loaded and
enabled, it will grab all CPUs in periodic calls to stop_machine and sit
in a configurable loop, looking for unexplainable latencies. Doing it
this way allows us to look for something stealing the CPU from Linux
without the kernel knowing - we report the statistics via debugfs.

Hope that helps! Thanks Linus!

Jon.


