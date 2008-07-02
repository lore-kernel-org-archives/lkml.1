Return-Path: <linux-kernel-owner+w=401wt.eu-S1763232AbYGBJfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763232AbYGBJfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYGBJf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:35:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34613 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbYGBJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:35:27 -0400
Message-ID: <486B4BDA.4060203@firstfloor.org>
Date: Wed, 02 Jul 2008 11:35:22 +0200
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
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806300106.38414.rjw@sisk.pl> <Pine.LNX.4.55.0806300205180.22548@cliff.in.clinika.pl> <200806301241.57781.rjw@sisk.pl> <Pine.LNX.4.55.0807020223140.6284@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0807020223140.6284@cliff.in.clinika.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Mon, 30 Jun 2008, Rafael J. Wysocki wrote:
> 
>> Well, there are lots of pieces of hardware that are not up to the
>> specifications, more or less, and I don't think that's a good enough reason
>> for us to refuse to support them.  The same applies to BIOSes IMO.
> 
>  Refusing to support broken hardware would provide some incentive to
> manufacturers to improve it, because people would rather not buy
> unsupported pieces of junk. 

For most consumer level hardware the vendors generally don't
really care if Linux runs on it or not.

Also they very rarely fix anything after release anyways because
they don't make enough money on it.

For server hardware that is different (vendors care about Linux,
but typically not about mainline, but about given RHEL/SLES  releases),
but even there we generally try to work around BIOS bugs
(at least as long as it is possible)
because it tends to be quite difficult logistically to require
a BIOS update. In the end it just hurts the user.

> I realise that may be impractical though 

It is.

> we would get the blame anyway, because "it runs the other OS just fine."

That is exactly what happens.

-Andi
