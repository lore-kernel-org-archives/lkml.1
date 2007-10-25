Return-Path: <linux-kernel-owner+w=401wt.eu-S1761673AbXJYXKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673AbXJYXKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761386AbXJYXKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:10:13 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:47548 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761089AbXJYXKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:10:10 -0400
To: dgc@sgi.com
CC: staubach@redhat.com, akpm@linux-foundation.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20071025224235.GZ995458@sgi.com> (message from David Chinner on
	Fri, 26 Oct 2007 08:42:35 +1000)
Subject: Re: [PATCH] VFS: new fgetattr() file operation
References: <E1Iketp-0005dr-00@dorka.pomaz.szeredi.hu> <471F4254.9040206@redhat.com> <E1IkgW1-0005i0-00@dorka.pomaz.szeredi.hu> <471F5EA2.8060203@redhat.com> <E1Iki8O-0005nu-00@dorka.pomaz.szeredi.hu> <20071025224235.GZ995458@sgi.com>
Message-Id: <E1IlBqA-0006yj-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 26 Oct 2007 01:10:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Oct 24, 2007 at 05:27:04PM +0200, Miklos Szeredi wrote:
> > > >> Wouldn't you be better off by attempting to implement an "open
> > > >> by ino" operation and an operation to get the generation count
> > > >> for the file and then modifying the network protocol of interest
> > > >> to use these as identifiers for the file to be manipulated?
> > > >>     
> > > >
> > > > You mean an "open by inode" on the userspace API?  My guess, it
> > > > wouldn't get very far.
> > > 
> > > This isn't a new idea and has been implemented on a variety of
> > > different systems.
> > 
> > Like?
> 
> XFS.
> 
> 'man open_by_handle'

Doesn't seem widely used, with 600 something google hits.  And in this
old thread Linus is not entirely enthusiastic about the concept:

  http://lkml.org/lkml/1999/1/11/244

Miklos
