Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbZBKMmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbZBKMmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbZBKMmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:42:23 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35464 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752763AbZBKMmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:42:22 -0500
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090211040806.GQ31509@parisc-linux.org>
References: <1232117771.3224.21.camel@localhost.localdomain>
	 <20090117211723.GB30719@parisc-linux.org>
	 <20090211040806.GQ31509@parisc-linux.org>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 07:42:19 -0500
Message-Id: <1234356139.3295.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 21:08 -0700, Matthew Wilcox wrote:
> On Sat, Jan 17, 2009 at 02:17:23PM -0700, Matthew Wilcox wrote:
> > On Fri, Jan 16, 2009 at 09:56:11AM -0500, James Bottomley wrote:
> > >       mpt fusion: Add separate msi enable disable for FC,SPI,SAS
> > 
> > I thought we rejected this one as being completely bogus?  I certainly
> > don't remember seeing even an excuse for it after I challenged it.
> 
> ... no response?

>From whom?  It's no less bogus than what they were doing previously.  I
happen to think the whole idea of drivers chosing msi/not msi by
parameters is bogus ... we just don't have a good platform way of
sorting it out at the moment.  In that absence, the driver maintainer
gets to fix up.

James


