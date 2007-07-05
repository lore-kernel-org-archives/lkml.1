Return-Path: <linux-kernel-owner+w=401wt.eu-S1760563AbXGEN62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563AbXGEN62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbXGEN6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:58:20 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:35644 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833AbXGEN6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:58:19 -0400
Date: Thu, 5 Jul 2007 14:57:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Paul Mackerras <paulus@samba.org>, Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Message-ID: <20070705135758.GB22177@srcf.ucam.org>
References: <18059.6726.218205.104212@cargo.ozlabs.ibm.com> <Pine.LNX.4.44L0.0707041104140.25704-100000@netrider.rowland.org> <18060.15591.556676.28935@cargo.ozlabs.ibm.com> <20070705091526.GA3084@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705091526.GA3084@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: removing refrigerator does not help with s2ram vs. fuse deadlocks (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 11:15:26AM +0200, Pavel Machek wrote:

> Now, if kernel needs FUSE services for some reason (that's the problem
> we hit in s2ram case, right?), we have a deadlock.
> 
> So main problem still seems to be "kernel should not depend on
> userland services during suspend", refrigerator or not.

And also "Userland should not depend on userland services", which is 
rather more of a problem.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
