Return-Path: <linux-kernel-owner+w=401wt.eu-S1423048AbXBBOhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423048AbXBBOhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423039AbXBBOhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:37:34 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42810 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423048AbXBBOhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:37:32 -0500
Date: Fri, 2 Feb 2007 14:50:03 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Ric Wheeler <ric@emc.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Mark Lord <liml@rtr.ca>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Message-ID: <20070202145003.525bd682@localhost.localdomain>
In-Reply-To: <45C32C7F.9050706@emc.com>
References: <200701301947.08478.liml@rtr.ca>
	<1170206199.10890.13.camel@mulgrave.il.steeleye.com>
	<45C2474E.9030306@rtr.ca>
	<1170366920.3388.62.camel@mulgrave.il.steeleye.com>
	<45C32C7F.9050706@emc.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> your system requirements are, what the system is trying to do (i.e., 
> when trying to recover a failing but not dead yet disk, IO errors should 
> be as quick as possible and we should choose an IO scheduler that does 
> not combine IO's).

If this is the right strategy for disk recovery for a given type of
device then this ought to be an automatic strategy. Most end users will
not have the knowledge to frob about in sysfs, and if the bad sector hits
at the wrong moment a sensible automatic recovery strategy is going to do
the right thing faster than human intervention, which may be some hours
away.

