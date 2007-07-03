Return-Path: <linux-kernel-owner+w=401wt.eu-S1761072AbXGCTzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761072AbXGCTzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbXGCTy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:54:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53392 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757753AbXGCTy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:54:58 -0400
Date: Tue, 3 Jul 2007 15:54:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <20070703194247.GB27098@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0707031553020.7671-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Matthew Garrett wrote:

> > I agree that in general the suspend process should not have to wait for 
> > a userspace callback to complete.  Indeed, there's no particular 
> > reason that anything running during STR should have to wait for 
> > something in userspace to complete.  Given that fact, I don't see 
> > anything wrong with freezing userspace when doing STR.
> 
> There's nothing wrong with it as such, it's just that our implementation 
> appears to suck in a myriad of small ways that keep cropping up and 
> biting people. Even without the sys_sync(), freezing processes results 
> in the suspend failing because syslog is stuck in D state and won't go 
> into the refrigerator.

Okay, I can believe that.  The proper response then is to fix the 
freezer, not eliminate it.  Has the syslog problem been reported on 
linux-pm?  I don't recall hearing of it before.

Alan Stern

