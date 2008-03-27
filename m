Return-Path: <linux-kernel-owner+w=401wt.eu-S1761382AbYC0Umt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382AbYC0Umt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 16:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbYC0Umk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 16:42:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757721AbYC0Umj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 16:42:39 -0400
Date: Thu, 27 Mar 2008 13:41:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-mtd@lists.infradead.org, rjw@sisk.pl, devzero@web.de,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       lenb@kernel.org, greg@kroah.com, linux-ide@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: some minor issues with 2.6.25-rc6-git7-default
Message-Id: <20080327134150.5f79dc0b.akpm@linux-foundation.org>
In-Reply-To: <200803271222.41579.david-b@pacbell.net>
References: <212011377@web.de>
	<200803260010.25327.rjw@sisk.pl>
	<20080325164236.1061d403.akpm@linux-foundation.org>
	<200803271222.41579.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 12:22:41 -0700
David Brownell <david-b@pacbell.net> wrote:

> On Tuesday 25 March 2008, Andrew Morton wrote:
> > 
> > > > Mar 23 09:17:02 opensuse103 kernel: physmap-flash: probe of physmap-flash.0 failed with error -12
> > 
> > There are many physmap-flashes in the tree. __Is this one
> > drivers/mtd/maps/physmap.c?
> 
> And there's a regression in mtd/maps/phsymap.c which should
> be resolved before 2.6.25 ships ... on some platforms it
> newly likes to oops on reboot.

I don't appear to have anything which touches physmap.c here.

> I don't have a URL for that patch, but ISTR it's been
> posted both to LKML and to linux-MTD.  (That doesn't
> include less-good versions I've seen too.)  If needed,
> I can dig it up, but I've been thinking this should have
> a signoff from MTD folk.

Yes, please dig it out and let's look at it.
