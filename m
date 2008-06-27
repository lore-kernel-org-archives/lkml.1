Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYF0AJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYF0AJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 20:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbYF0AIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 20:08:49 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62856 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751540AbYF0AIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 20:08:48 -0400
Date: Fri, 27 Jun 2008 01:06:51 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <200806262152.02099.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0806270102051.31618@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au>
 <Pine.LNX.4.55.0806202241120.19614@cliff.in.clinika.pl>
 <20080621014047.GA20908@srcf.ucam.org> <200806262152.02099.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008, Rafael J. Wysocki wrote:

> Well, actually, I'm not sure that will work.  I have only found
> acpi_skip_timer_override being set to 1 in two places, but it doesn't seem to
> be read anywhere.  What am I missing?

 I believe I removed all the occurences.  I am waiting for a proposal of a
quirk based on the DSDT ID -- my time is a bit too limited to study the
internals of our ACPI code at the moment; sorry about that.  I will
complement it with a change to remove IRQ0 from I/O APIC tables as
promised then; this piece of code I am quite familiar with.

  Maciej
