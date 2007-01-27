Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbXA0VlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbXA0VlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 16:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbXA0VlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 16:41:21 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35426 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbXA0VlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 16:41:20 -0500
Date: Sat, 27 Jan 2007 13:41:16 -0800
From: Andrew Morton <akpm@osdl.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
Message-Id: <20070127134116.06bdadd8.akpm@osdl.org>
In-Reply-To: <45BBC444.8090109@imap.cc>
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
	<6bffcb0e0701270837i1ec40560l6e61e8876177e9da@mail.gmail.com>
	<45BBC444.8090109@imap.cc>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 22:29:40 +0100
Tilman Schmidt <tilman@imap.cc> wrote:

> Am 27.01.2007 17:37 schrieb Michal Piotrowski:
> > On 26/01/07, akpm@osdl.org <akpm@osdl.org> wrote:
> >> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> >>
> >>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> >>
> > 
> > It's probably not mm snapshot related. This driver is just broken.
> 
> It probably *is* mm snapshot related. This driver compiles and works
> just fine in 2.6.19.2, 2.6.20-rc6 and 2.6.20-rc4-mm1.
> 
> > drivers/isdn/gigaset/bas-gigaset.c: In function 'dump_urb':
> > drivers/isdn/gigaset/bas-gigaset.c:258: error: 'struct urb' has no
> > member named 'bandwidth'
> 
> In current stable and mm releases, 'struct urb' *does* have a member
> named 'bandwidth'. If some mm patch removes that member then it is
> the responsibility of that patch to adapt all users of that structure
> accordingly.
> 

yup, there's a patch in Greg's USB tree which removes the bandwidth field. 
Mostly.  I fixed it up.

I have everything compiling now, mostly.  The number of fixes which were
needed was just extraordinary.  I'm thinking about making changes...
