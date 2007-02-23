Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbXBWLFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbXBWLFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932281AbXBWLFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:05:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59282 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932279AbXBWLFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:05:09 -0500
Date: Fri, 23 Feb 2007 12:08:45 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH]: pcmcia - spot slave decode flaws (for testing)
Message-ID: <20070223120845.19203fcb@lxorguk.ukuu.org.uk>
In-Reply-To: <45DEC5A0.7050107@garzik.org>
References: <20070220181836.524e5f9a@localhost.localdomain>
	<45DEC5A0.7050107@garzik.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Code looks OK. Not applied due to "for testing" note.
> 
> General comment:  it might be nice to do this in the core, just as a 
> sanity check for a variety of problems, past, present and future.

We tried that with old IDE and all hell broke loose. Lots of virtual disk
stuff and raid volumes have non-unique serial numbers. We even found a
case of identically serial numbered Maxtor drives.

It needs to stay in pcmcia, which is the only place we've seen the
duplication.



Alan
