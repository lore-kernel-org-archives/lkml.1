Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbYJYBk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbYJYBk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 21:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYJYBkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 21:40:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbYJYBkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 21:40:17 -0400
Date: Fri, 24 Oct 2008 21:40:04 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Greg KH <greg@kroah.com>
cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [patch 11/27] dm exception store: refactor zero_area
In-Reply-To: <20081024053639.GA17405@kroah.com>
Message-ID: <Pine.LNX.4.64.0810242125001.5826@hs20-bc2-1.build.redhat.com>
References: <20081024042023.054190751@mini.kroah.org> <20081024043423.GL30828@kroah.com>
 <20081024053639.GA17405@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Oct 2008, Greg KH wrote:

> On Thu, Oct 23, 2008 at 09:34:23PM -0700, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us 
> > know.
> > 
> > ------------------
> > From: Alasdair G Kergon <agk@redhat.com>
> > 
> > commit 7c9e6c17325fab380fbe9c9787680ff7d4a51abd upstream
> > 
> > Use a separate buffer for writing zeroes to the on-disk snapshot
> > exception store, make the updating of ps->current_area explicit and
> > refactor the code in preparation for the fix in the next patch.
> > 
> > No functional change.
> > 
> > Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/md/dm-exception-store.c |  103 ++++++++++++++++++++++++++--------------
> >  1 file changed, 69 insertions(+), 34 deletions(-)
> 
> Oops, this patch causes a build error:
> 
> drivers/md/dm-exception-store.c:235: error: implicit declaration of function 'area_location'
> drivers/md/dm-exception-store.c:241: error: 'area' undeclared (first use in this function)
> drivers/md/dm-exception-store.c:241: error: (Each undeclared identifier is reported only once
> drivers/md/dm-exception-store.c:241: error: for each function it appears in.)
> 
> I'll drop this one, and the follow-on dm-exception-store.c patch as
> well, as that was the only reason this patch was added.
> 
> If you want to redo these two patches, and get them into the
> 2.6.27-stable tree, please do so and send them to stable@kernel.org.
> 
> thanks,
> 
> greg k-h

You should apply this one patch before:
ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-exception-store-introduce-area_location-function.patch

Mikulas
