Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbYF3JY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbYF3JY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760227AbYF3JYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:24:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55457 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbYF3JYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:24:45 -0400
Message-ID: <4868A659.2080308@firstfloor.org>
Date: Mon, 30 Jun 2008 11:24:41 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <20080629200210.GB31633@elte.hu> <Pine.LNX.4.55.0806292104560.22548@cliff.in.clinika.pl> <200806300106.38414.rjw@sisk.pl> <Pine.LNX.4.55.0806300205180.22548@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806300205180.22548@cliff.in.clinika.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  That is certainly true for standard hardware.  We have to take
> responsibility for own bugs, sure.  I cannot readily understand why you
> apparently try to imply hardware vendors do not.

Sorry Maciej, you're totally off base on that. On consumer hardware
vendors very rarely fix anything after release of the machine
and in general users expect Linux to work around any BIOS or
hardware bugs that happen (especially if it's a regression and worked
before)

So you either need to provide a workaround for the problem or your
patches should be reverted.

-Andi

