Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbXEIXFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbXEIXFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759506AbXEIXEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:04:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:33478 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759277AbXEIXE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:04:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RJydy/38c/zXsPT5ayg14Gr2yblu8NwpoInXFDVakzX098QHtOu3Urfv6ZOmhx7+Y1cUh0Pms6bizeHGCYZmP2HEQLRbJN/V5q37iIVVJg5Sx7My7Dl+89BJFu8D+qR+DefYUm0LX3yrMHYIJiaxc0x6EAaigXeeVxHhtHrbX90=
Message-ID: <9a8748490705091604l32b0e6depbc079f69897b34e0@mail.gmail.com>
Date: Thu, 10 May 2007 01:04:24 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: remove broken URLs from net drivers' output
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>,
       "Markus Dahms" <dahms@fh-brandenburg.de>
In-Reply-To: <46424E12.9070307@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705092102.l49L2Re6028694@hera.kernel.org>
	 <46424E12.9070307@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/07, Jeff Garzik <jeff@garzik.org> wrote:
> Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2c2a8c531e953c753b06605c8ad6a9161ca527fa
> > Commit:     2c2a8c531e953c753b06605c8ad6a9161ca527fa
> > Parent:     b96687768a9ac0fdd005c7700093ebb24b93450f
> > Author:     Markus Dahms <dahms@fh-brandenburg.de>
> > AuthorDate: Wed May 9 07:58:10 2007 +0200
> > Committer:  Adrian Bunk <bunk@stusta.de>
> > CommitDate: Wed May 9 08:58:18 2007 +0200
> >
> >     remove broken URLs from net drivers' output
> >
> >     Remove broken URLs (www.scyld.com) from network drivers' logging output.
> >     URLs in comments and other strings are left intact.
> >
> >     Signed-off-by: Markus Dahms <dahms@fh-brandenburg.de>
> >     Acked-by: Jesper Juhl <jesper.juhl@gmail.com>
> >     Acked-by: Alan Cox <alan@redhat.com>
> >     igned-off-by: Adrian Bunk <bunk@stusta.de>
> > ---
> >  drivers/net/3c509.c     |    5 ++---
> >  drivers/net/3c59x.c     |    2 +-
> >  drivers/net/atp.c       |    8 +++-----
> >  drivers/net/eepro100.c  |    2 +-
> >  drivers/net/epic100.c   |   10 ++++------
> >  drivers/net/natsemi.c   |    1 -
> >  drivers/net/ne2k-pci.c  |    3 +--
> >  drivers/net/sundance.c  |    3 +--
> >  drivers/net/yellowfin.c |    1 -
> >  9 files changed, 13 insertions(+), 22 deletions(-)
>
> Grumble...  This stuff should go through my tree.
>
>         Jeff
>

Note, just for the record; I never explicitly added an Acked-by to
this patch, I only said in a conversational email that it made sense
to me...
I don't actually mind, in this case, to have an Acked-by tagged on
with my name,  but in general I think that such lines should only be
added when people explicitly say Acked-by: John Doe, or something like
"Feel free to add my ACK to this" etc.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
