Return-Path: <linux-kernel-owner+w=401wt.eu-S1761143AbXGCUXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761143AbXGCUXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbXGCUXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:23:38 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:42302 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680AbXGCUXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:23:37 -0400
Date: Tue, 3 Jul 2007 21:23:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Message-ID: <20070703202329.GA27927@srcf.ucam.org>
References: <20070703194247.GB27098@srcf.ucam.org> <Pine.LNX.4.44L0.0707031553020.7671-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0707031553020.7671-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 03:54:55PM -0400, Alan Stern wrote:
> On Tue, 3 Jul 2007, Matthew Garrett wrote:
> > There's nothing wrong with it as such, it's just that our implementation 
> > appears to suck in a myriad of small ways that keep cropping up and 
> > biting people. Even without the sys_sync(), freezing processes results 
> > in the suspend failing because syslog is stuck in D state and won't go 
> > into the refrigerator.
> 
> Okay, I can believe that.  The proper response then is to fix the 
> freezer, not eliminate it.  Has the syslog problem been reported on 
> linux-pm?  I don't recall hearing of it before.

See the start of this thread. It's just not clear what the freezer buys 
us - removing it gets rid of a load of subtle issues and complexity, and 
turns system suspend into something that looks more like runtime 
suspend (which might then encourage people to get runtime suspend 
right...)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
