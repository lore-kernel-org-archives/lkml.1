Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbXF0Q0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbXF0Q0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbXF0Q03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:26:29 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42257 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758225AbXF0Q02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:26:28 -0400
Date: Wed, 27 Jun 2007 18:26:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
Message-ID: <20070627162650.GP1094@stusta.de>
References: <200706271653.58870.a1426z@gawab.com> <20070627155254.GO1094@stusta.de> <46828B6C.6010203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46828B6C.6010203@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 12:08:12PM -0400, Chuck Ebbert wrote:
> On 06/27/2007 11:52 AM, Adrian Bunk wrote:
> > On Wed, Jun 27, 2007 at 04:53:58PM +0300, Al Boldi wrote:
> >> Al Viro wrote:
> >>> On Wed, Jun 27, 2007 at 11:18:36AM +0200, Zolt?n HUBERT wrote:
> >>>> And as I understand it, this is (was ?) the whole point of
> >>>> stable/development kernels. "We" can trust a newer stable
> >>>> kernel to be a drop-in replacement for an older stable
> >>>> kernel (from the same series), while development kernels
> >>>> need time to stabilise with the new whizz-bang-pfouit stuff
> >>>> that you all so nicely add.
> >>> "Drop-in" in which sense?  That out-of-tree modules keep working?
> >>> Not really...
> >> Al, be reasonable.  There are many out-of-tree GPL modules that won't be 
> >> accepted into mainline, never mind those that shouldn't be accepted.  But 
> >> these modules do have a right to not be obsoleted by constant API changes.
> > 
> > "have a right" are strong words.
> > Who is granting them this right?
> > 
> >> You are effectively inhibiting the development of an out-of-tree GPL module 
> >> pool, by constantly pulling the rug under that community.
> >>
> >> Do you think this is fair?
> > 
> > Why are these modules not submitted for inclusion into the kernel?
> > 
> 
> I was trying to figure that out for this one:
> 
> http://code.ximeta.com/trac-ndas
> 
> No mention of ever trying to get this upstream AFAICT... but this is
> interesting:
> 
>   The linux market is limited comparing that of MS Windows.
>   it is very hard for us to support the various linux distros.
>   we, Ximeta, are trying to support those requests as many as
>   we can, though the resources are very limited.

One of their module contains a 180 kB binary blob and
MODULE_LICENSE("Proprietary, Send bug reports to support@ximeta.com").

And it calls tons of functions EXPORT_SYMBOL'ed by their other
3 modules that are MODULE_LICENSE("Dual BSD/GPL")...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

