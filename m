Return-Path: <linux-kernel-owner+w=401wt.eu-S1760688AbXKTP5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688AbXKTP5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758055AbXKTP5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:57:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951AbXKTP5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:57:41 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: [patch][v2] x86, ptrace: support for branch trace store(BTS)
Date: Tue, 20 Nov 2007 16:57:37 +0100
User-Agent: KMail/1.9.6
Cc: "dean gaudet" <dean@arctic.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org
References: <029E5BE7F699594398CA44E3DDF55444F3AEA7@swsmsx413.ger.corp.intel.com> <alpine.DEB.0.99999.0711200729570.765@twinlark.arctic.org> <029E5BE7F699594398CA44E3DDF55444F71289@swsmsx413.ger.corp.intel.com>
In-Reply-To: <029E5BE7F699594398CA44E3DDF55444F71289@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711201657.37508.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >and it seems like this patch and perfmon2 are going to have to 
> >live with 
> >each other... since they both require the use of the DS save area...
> 
> Hmmm, this might require some synchronization between those two.
> 
> Do you know how (accesses to) MSR's are managed by the kernel?

There is a simple MSR allocator in the nmi watchdog code. It is very
simple though and was only intended for performance counters originally
so you might need to enhance it first for complicated things.

-Andi
