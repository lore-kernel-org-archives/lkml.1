Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbXENGnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbXENGnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 02:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXENGnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 02:43:16 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549AbXENGnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 02:43:15 -0400
Date: Sun, 13 May 2007 23:42:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-Id: <20070513234243.2b17bc2a.akpm@linux-foundation.org>
In-Reply-To: <1179072770.22481.265.camel@localhost.localdomain>
References: <20070430102837.748238000@linutronix.de>
	<20070511132846.5ebf4437.akpm@linux-foundation.org>
	<200705112302.47726.rjw@sisk.pl>
	<200705112309.15996.rjw@sisk.pl>
	<20070511235607.83ad0eb5.akpm@linux-foundation.org>
	<1178959563.22481.126.camel@localhost.localdomain>
	<20070512020056.a24cf472.akpm@linux-foundation.org>
	<1179072770.22481.265.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 18:12:50 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sat, 2007-05-12 at 02:00 -0700, Andrew Morton wrote:
> > Still hangs in the same fashion, sorry.
> > 
> > It's peculiar that the hang happens when acpi_evaluate_object() hits its
> > return statement.  Any theories there?
> 
> I assume you have a printk right before the return and one after the
> call to acpi_evaluate_object().
> 
> Can you dump the stack at the point before the return, so we can see if
> the stack is corrupt there ? A WARN_ON(1) should do the trick.
> 

It all looks clean.  I spose I should do a hex dump and a byte-by-byte
walkthough, but time is short...
