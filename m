Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbXE3OJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbXE3OJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbXE3OIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:08:50 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:33994 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284AbXE3OIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:08:48 -0400
Date: Wed, 30 May 2007 15:07:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: nigel@nigel.suspend2.net, Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20070530140739.GB29514@srcf.ucam.org>
References: <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org> <20070530124027.GA27942@srcf.ucam.org> <1180531067.24891.1.camel@nigel.suspend2.net> <200705301604.23312.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705301604.23312.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 04:04:22PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, 30 May 2007 15:17, Nigel Cunningham wrote:
> > On Wed, 2007-05-30 at 13:40 +0100, Matthew Garrett wrote:
> > > So keep the driver layers read-only and unfreeze the processes after 
> > > doing the atomic copy.
> > 
> > I know you probably won't care, but that's not an option for Suspend2 -
> > I get the possibility of a full image by overwriting LRU pages that were
> > saved prior to the atomic copy.
> 
> This generally is a problem, not only for suspend2. :-)
> 
> Once you've unfrozen the user land, we can't rely on the hibernation image any
> more, because some tasks may cause the on-disk filesystems' state to change.

Hence "keep the driver layers read-only" :) 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
