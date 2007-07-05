Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbXGEPDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbXGEPDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 11:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbXGEPDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 11:03:45 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:60991 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbXGEPDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 11:03:44 -0400
Date: Thu, 5 Jul 2007 16:03:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Paul Mackerras <paulus@samba.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Message-ID: <20070705150301.GB23647@srcf.ucam.org>
References: <18059.6726.218205.104212@cargo.ozlabs.ibm.com> <200707051641.39998.rjw@sisk.pl> <20070705143918.GA23248@srcf.ucam.org> <200707051704.48137.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707051704.48137.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: removing refrigerator does not help with s2ram vs. fuse deadlocks (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 05:04:47PM +0200, Rafael J. Wysocki wrote:
> On Thursday, 5 July 2007 16:39, Matthew Garrett wrote:
> > Why?
> 
> You have processes that don't react to signals, because some other user land
> task is misbehaving.  I'd call that ugly at the very least.

It already happens with, say, NFS. Don't think about it in terms of a 
userland task misbehaving - think of it in terms of a resource becoming 
unavailable.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
