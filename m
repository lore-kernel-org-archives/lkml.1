Return-Path: <linux-kernel-owner+w=401wt.eu-S932713AbXBWPzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbXBWPzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 10:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932716AbXBWPzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 10:55:12 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:33313 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932713AbXBWPzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 10:55:11 -0500
Date: Fri, 23 Feb 2007 10:54:55 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
Message-ID: <20070223155455.GB22466@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl> <m3hctfqjna.fsf@maximus.localdomain> <20070221224027.GK22464@csclub.uwaterloo.ca> <200702212355.25601.s0348365@sms.ed.ac.uk> <m3bqjnrntu.fsf@maximus.localdomain> <45DF0C29.2080201@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DF0C29.2080201@xs4all.nl>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 04:45:45PM +0100, Udo van den Heuvel wrote:
> Small update:
> 
> I will try a different case with a different dual PCI riser card soon.
> This Morex riser has DN20-31 or so, so more options.
> Could this help solve my irq issue? (try 4 consecutive DNs until I have
> the right mapping?)

It all depends on the BIOS.  If the bios doesn't assign interrupts to a
given DN, then there is nothing to do about it really.  You could hack
the kernel or boot loader to do the job that the bios didn't do, but
that's about it.

--
Len Sorensen
