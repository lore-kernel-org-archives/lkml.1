Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYFTL5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYFTL5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbYFTL5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:57:37 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41020 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbYFTL5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:57:36 -0400
Date: Fri, 20 Jun 2008 12:57:14 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Message-ID: <20080620115714.GC8637@srcf.ucam.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806190225.51088.rjw@sisk.pl> <Pine.LNX.4.55.0806200024170.12929@cliff.in.clinika.pl> <200806201353.59083.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806201353.59083.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 01:53:58PM +0200, Rafael J. Wysocki wrote:

> What exactly I observe is that in this case:
> 1) The cooling fan is 100% on, as though the box were overheating, which seems
>    to indicate some serious confusion of the platform (the mechanism turning
>    the fan 100% on is supposed to be transparent to software).
> 2) Everything seems to slow down substantially, at least as soon as X is
>    started.

What does ACPI claim the trip points are set to in this case? On the 
6125, if IRQ 2 is enabled in the APIC then the DSDT sets all the thermal 
trip points to 16 degrees C. I suspect this means that enabling IRQ 2 is 
the wrong thing to do on this chipset.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
