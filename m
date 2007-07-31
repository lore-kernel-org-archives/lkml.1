Return-Path: <linux-kernel-owner+w=401wt.eu-S939739AbXGaBVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939739AbXGaBVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbXGaBVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:21:09 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:3067 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbXGaBVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:21:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ld5Jc8phuI1fZkDDdWjea6ezgxaZEscxBmw89DIGXxDaCKu/Bbckz040wDHEGBdEgXM4GKsHTwvjP8fHJCa6wtYn0eSzwSg6sBRDSs7c1XTTfrGUweib6W/WzVZ9zyd4GSh7UEw9EKd0r14nsY1D9Xjq/ZaL2qyLLUnZD+F686s=
Message-ID: <a8e1da0707301821n1532669el4d6f2f8cfc90c406@mail.gmail.com>
Date: Tue, 31 Jul 2007 01:21:05 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Satyam Sharma" <satyam@infradead.org>
Subject: Re: 2.6.23-rc1-mm1
Cc: "Christoph Hellwig" <hch@lst.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Grant Wilson" <grant.wilson@zen.co.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.999.0707310344430.17287@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	 <20070729164946.0b86a414@the-diner.swandive.local>
	 <a8e1da0707300258k4ee5ed93yadd9e87af45b9330@mail.gmail.com>
	 <20070730112720.cdc6a8c4.akpm@linux-foundation.org>
	 <20070730184203.GA14219@lst.de>
	 <alpine.LFD.0.999.0707310344430.17287@enigma.security.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 7/30/07, Satyam Sharma <satyam@infradead.org> wrote:
>
>
> On Mon, 30 Jul 2007, Christoph Hellwig wrote:
>
> > On Mon, Jul 30, 2007 at 11:27:20AM -0700, Andrew Morton wrote:
> > > ho hum, crap.  Yes, ioctl_by_bdev() doesn't have a file* and so it makes
> > > unlocked_ioctl() rather tricky.  We could cook up a `struct file' on the
> > > stack (we do that in various places), but that sucks.
> > >
> > > Christoph, have you any clever suggestions?
> >
> > There's two ways to deal with it, one ugly and quick and one to do it
> > right.
> >
> > The quick hack is to fake up a file struct similar to blkdev_get().
>
Why pick file as param in unlocked_ioctl, why not inode, could someone
explain this? THX.
