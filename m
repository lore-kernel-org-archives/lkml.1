Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbYF2UFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbYF2UFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 16:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbYF2UEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 16:04:32 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62395 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760379AbYF2UE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 16:04:29 -0400
Date: Sun, 29 Jun 2008 21:03:29 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <20080629192353.GA9132@srcf.ucam.org>
Message-ID: <Pine.LNX.4.55.0806292057270.22548@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806262152.02099.rjw@sisk.pl>
 <Pine.LNX.4.55.0806270102051.31618@cliff.in.clinika.pl> <200806291600.29059.rjw@sisk.pl>
 <Pine.LNX.4.55.0806291952590.22548@cliff.in.clinika.pl>
 <20080629192353.GA9132@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008, Matthew Garrett wrote:

> The DSDT can't be updated without the BIOS being updated, and the DMI 
> information gives us a BIOS version string that can be matched against 
> if a fixed version is ever released. I'd be in favour of doing it with 
> DMI on the grounds that it's how we already handle machine-specific 
> quirks rather than adding new code to do it.

 Is the DMI ID *guaranteed* to be changed with an update to the DSDT?  
Anyway, you cannot imply from a given DMI ID a broken DSDT is present, so
you will have to repeat the experience of adding another DMI ID whenever a
user hits this broken DSDT with another piece of hardware.  As long as you
are able to pull this piece of information from that user, that is...

  Maciej
