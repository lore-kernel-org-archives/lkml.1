Return-Path: <linux-kernel-owner+w=401wt.eu-S964863AbXBQXMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863AbXBQXMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 18:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964861AbXBQXMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 18:12:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48110 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992796AbXBQXMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 18:12:17 -0500
Date: Sat, 17 Feb 2007 15:12:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: mm snapshot broken-out-2007-02-17-03-25.tar.gz uploaded
Message-Id: <20070217151210.f962716f.akpm@linux-foundation.org>
In-Reply-To: <6bffcb0e0702171423y3440f8d3n1caa31904ee2eee9@mail.gmail.com>
References: <200702171127.l1HBRnhe025635@shell0.pdx.osdl.net>
	<45D74B37.1040507@googlemail.com>
	<20070217114601.19544615.akpm@linux-foundation.org>
	<6bffcb0e0702171158o5f384e60sacae4e45563d7321@mail.gmail.com>
	<20070217120402.ec517938.akpm@linux-foundation.org>
	<6bffcb0e0702171423y3440f8d3n1caa31904ee2eee9@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Feb 2007 23:23:17 +0100 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:

> On 17/02/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Sat, 17 Feb 2007 20:58:55 +0100 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
> >
> > > On 17/02/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > On Sat, 17 Feb 2007 19:36:39 +0100 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > > >
> > > > >
> > > > > akpm@linux-foundation.org napisał(a):
> > > > > > The mm snapshot broken-out-2007-02-17-03-25.tar.gz has been uploaded to
> > > > > >
> > > > > >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-17-03-25.tar.gz
> > > > > >
> > > > >
> > > > > BUG: unable to handle kernel paging request at virtual address 6b6b6b6f
> > > >
> > > > hm, how did you make that happen?
> > > >
> > >
> > > I don't know. I can reproduce this bug.
> > >
> >
> > Could you bisect it please?  The patches to suspect are
> [..]
> > For git-block, do
> >
> >         quilt pop scsi-megaraid_sas-return-sync-cache-call-with-success.patch
> >
> > and retest.  If that doesn't fail, do
> >
> >         quilt push git-block-xfs-barriers-broke.patch
> >
> > and retest.
> >
> 
> Ok, this must be a git-block-* stuff.
> 
> Jens, can you take a look at this bug?
> http://www.ussg.iu.edu/hypermail/linux/kernel/0702.2/0646.html
> 

I wonder why.  I can't make it happen on two machines, scsi, sata and IDE. 
And afaict git-block isn't changed from 2.6.20-mm1.

Are you sure?
