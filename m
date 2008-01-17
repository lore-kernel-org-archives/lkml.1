Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbYAQB2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYAQB2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 20:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYAQB2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 20:28:15 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:51645 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751270AbYAQB2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 20:28:14 -0500
Date: Thu, 17 Jan 2008 10:27:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom CDROM drive on SEGA Dreamcast
Message-ID: <20080117012743.GD14107@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-sh <linux-sh@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1200007549.6349.16.camel@localhost.localdomain> <1200088609.6213.3.camel@localhost.localdomain> <20080112053630.0ccb290e.akpm@linux-foundation.org> <1200351607.6196.4.camel@localhost.localdomain> <1200352635.6196.8.camel@localhost.localdomain> <1200527877.6243.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200527877.6243.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 11:57:57PM +0000, Adrian McMenamin wrote:
> 
> On Mon, 2008-01-14 at 23:17 +0000, Adrian McMenamin wrote:
> > On Mon, 2008-01-14 at 23:00 +0000, Adrian McMenamin wrote:
> > > From: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> > >  
> > > This patch adds support for the GD-Rom drive, SEGA's proprietary
> > > implementation of an IDE CD Rom for the SEGA Dreamcast. This driver
> > > implements Sega's Packet Interface (SPI) - at least partially. It will
> > > also read disks in SEGA's propreitary GD format.
> > > 
> > > Unlike previous drivers (which were never in mainline) this uses DMA and
> > > not PIO to read disks. It is a new driver, not a refactoring of old
> > > drivers. 
> > > 
> > > Hopefully this patch addresses some issues that have been raised by
> > > Andrew. Jens previously ack'ed this, but I've left that off (though the
> > > IO code hasn't really been touched).
> > >  
> > > Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> > >  
> > > (Jens - this awaits your ack before going in Paul's queue for the 2.6.25
> > > window)
> > >  
> > 
> I think I have now removed all the whitespace issues.
> 
> Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
Looks better. __devexit/__devexit_p()?
