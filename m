Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbYBWTX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbYBWTX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbYBWTXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:23:22 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211AbYBWTXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:23:21 -0500
Date: Sat, 23 Feb 2008 11:22:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] [patch] fuse: fix permission checking
Message-Id: <20080223112251.f797c4b6.akpm@linux-foundation.org>
In-Reply-To: <20080223190859.GB8641@kroah.com>
References: <E1JPxjP-0004sQ-5O@pomaz-ex.szeredi.hu>
	<20080222231934.GA30703@kroah.com>
	<E1JSqqR-00035e-8N@pomaz-ex.szeredi.hu>
	<20080223190859.GB8641@kroah.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 11:08:59 -0800 Greg KH <greg@kroah.com> wrote:

> On Sat, Feb 23, 2008 at 10:38:59AM +0100, Miklos Szeredi wrote:
> > > On Fri, Feb 15, 2008 at 11:23:47AM +0100, Miklos Szeredi wrote:
> > > > This is for 2.6.25 and 2.6.24.y, but NOT for 2.6.23.y.
> > > > 
> > > > Thanks,
> > > > Miklos
> > > > ----
> > > > 
> > > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > > 
> > > > I added a nasty local variable shadowing bug to fuse in 2.6.24, with
> > > > the result, that the 'default_permissions' mount option is basically
> > > > ignored.
> > > 
> > > When this goes into Linus's tree, can you let us know along with the git
> > > commit id?
> > 
> > I'd really like to see this in 2.6.24.3.  How much time is left?
> > Should I bypass Andrew and submit to Linus ASAP?
> 
> There will be a .24.4 soon afterward (week or so), so don't feel like
> you have to rush.  Unless this is some kind of security issue?
> 

I'll be sending a bunch of fixes to Linus this weekend, including this patch.
