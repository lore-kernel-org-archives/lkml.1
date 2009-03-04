Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbZCDXZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbZCDXZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 18:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbZCDXZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 18:25:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:36768 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbZCDXZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 18:25:50 -0500
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090304080212.GA1489@ucw.cz>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <200902032253.42709.rjw@sisk.pl> <1233700390.16867.97.camel@pasglop>
	 <200902032344.22348.rjw@sisk.pl> <1233702327.16867.109.camel@pasglop>
	 <alpine.LFD.2.00.0902031514510.3247@localhost.localdomain>
	 <20090304080212.GA1489@ucw.cz>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 10:25:04 +1100
Message-Id: <1236209104.6696.73.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> As long as we claim to support cpu hotplug, suspending the cpus early
> should work. User might have unplugged the cpu manually...
> 
> If something is broken in acpi, we may need to disable  cpu*/onlone on
>  affected systems.

You seem to miss some context here... it seems that ACPI mandates that
CPUs are suspended after devices and you know that we can't just start
blacklisting half of the machines out there just because we happen not
to do the same as what Windows does...

So let's be on the safe side.

Cheers,
Ben

