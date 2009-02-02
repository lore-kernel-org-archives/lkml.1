Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbZBBWt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbZBBWt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZBBWtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:49:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:41959 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbZBBWtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:49:17 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <alpine.LFD.2.00.0902021241430.3247@localhost.localdomain>
	 <alpine.LFD.2.00.0902021251130.3247@localhost.localdomain>
	 <200902022239.02453.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 09:48:47 +1100
Message-Id: <1233614927.18767.121.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 14:05 -0800, Linus Torvalds wrote:
> Well, I don't think anybody wants to (or necessarily has the ability) 
> touch ACPI internals.
> 
Somebody has a rough idea of what underlying kernel support ACPI uses ?
I know from discussions with Len that it's mostly mutexes... timers
too ?

It might end up being trivial to make it safe to call early with
interrupts off with the trick you mentioned, since it's really just the
same as boot as you mentioned.. ie, it's actually safe to take mutexes
etc... since we -know- no other CPU is running and we aren't scheduling
etc...

Ben.


