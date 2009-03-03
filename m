Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbZCCVGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbZCCVGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 16:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbZCCVGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:06:38 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42154 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753099AbZCCVGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:06:37 -0500
Date: Tue, 3 Mar 2009 16:06:34 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: Boaz Harrosh <bharrosh@panasas.com>, Jan Engelhardt <jengelh@medozas.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       <linux-scsi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: Large amount of scsi-sgpool objects
In-Reply-To: <20090303205637.GA26196@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0903031603430.4082-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, Ingo Molnar wrote:

> > > The above diff looks like something that was sent in the past to the mailing
> > > list, but only half of it. It was sent by Alan Stern. It might patch but
> > > it is not applicable any more because of changes made since. 
> > 
> > That's right; it is an old version of a patch which no longer applies 
> > to the current kernel (the __scsi_release_buffers() call was added 
> > after that patch was written).  An updated version of the patch has 
> > been submitted here:
> > 
> > 	http://marc.info/?l=linux-scsi&m=123507641620649&w=2
> 
> ah, i missed that patch because you used the exact same subject 
> line. (The standard lkml convention is to use "v2, v3" 
> postfixes, to make sure people notice that it's an update. It 
> helps avoid such mistakes.)

Sorry, I just forgot to update the subject line.

> I've picked up the v2 delta below into tip:out-of-tree - thanks 
> Alan! This will also get into the next -rt release.
> 
> Both patches will go away from the tip:out-of-tree hot-fixes 
> branch once the fix is upstream via the SCSI tree.
> 
> Any ETA for that? The lockup bug it fixes is very serious.

It's entirely up to James.

Alan Stern

