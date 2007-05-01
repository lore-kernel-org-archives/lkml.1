Return-Path: <linux-kernel-owner+w=401wt.eu-S1031606AbXEAJIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031606AbXEAJIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031607AbXEAJIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:08:42 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031606AbXEAJIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:08:41 -0400
Date: Tue, 1 May 2007 02:08:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-pcmcia@lists.infradead.org
Subject: Re: pcmcia ioctl removal
Message-Id: <20070501020820.05f0c037.akpm@linux-foundation.org>
In-Reply-To: <20070501085710.GA13488@1wt.eu>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<20070501084623.GB14364@infradead.org>
	<20070501085710.GA13488@1wt.eu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 10:57:10 +0200 Willy Tarreau <w@1wt.eu> wrote:

> Hi Christoph,
> 
> On Tue, May 01, 2007 at 09:46:23AM +0100, Christoph Hellwig wrote:
> > >  pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
> > 
> > ...
> > 
> > > Dominik is busy.  Will probably re-review and send these direct to Linus.
> > 
> > The patch above is the removal of cardmgr support.  While I'd love to
> > see this cruft gone it definitively needs maintainer judgement on whether
> > they time has come that no one relies on cardmgr anymore.
> 
> Well, I've not followed evolutions in this area for a long time. Here's
> what I get on my notebook :
> 
> willy@wtap:~$ uname -r
> 2.6.20-wt3-wtap
> willy@wtap:~$ ps auxw|grep card   
> root      1216  0.0  0.0     0    0 ?        S<   Apr28   0:00 [pccardd]
> root      1221  0.0  0.0     0    0 ?        S<   Apr28   0:00 [pccardd]
> root      1244  0.0  0.0     0    0 ?        S<   Apr28   0:00 [pccardd]
> root      1251  0.0  0.0     0    0 ?        Ss   Apr28   0:00 /sbin/cardmgr
> 

Yes, that seems premature.  feature-removal.txt is pretty useless for
getting poeple off old tools.  If we're ever to make this migration we'll
need loud and scary printks coming out of the kernel.  Probably it'll take
another year or two to get there *once* we've done that.

