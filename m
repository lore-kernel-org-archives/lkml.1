Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbXGEO0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbXGEO0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbXGEO0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:26:38 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:52076 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758849AbXGEO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:26:37 -0400
Date: Thu, 5 Jul 2007 15:26:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Paul Mackerras <paulus@samba.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Message-ID: <20070705142600.GB22598@srcf.ucam.org>
References: <18059.6726.218205.104212@cargo.ozlabs.ibm.com> <20070705091526.GA3084@elf.ucw.cz> <20070705135758.GB22177@srcf.ucam.org> <200707051628.12199.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707051628.12199.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: removing refrigerator does not help with s2ram vs. fuse deadlocks (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 04:28:11PM +0200, Rafael J. Wysocki wrote:
> On Thursday, 5 July 2007 15:57, Matthew Garrett wrote:
> > And also "Userland should not depend on userland services", which is 
> > rather more of a problem.
> 
> I think you're oversimplifying it, as far as FUSE is concerned.
> 
> Namely, if there are two userland tasks, A and B, and B is uninterruptible,
> because A is blocked, then this is not a usual situation.

Fuse is one case of it occuring, and if we end up with more userspace 
drivers then the problem is only going to get worse.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
