Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbXLGTgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbXLGTgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 14:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbXLGTgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 14:36:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37092 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbXLGTf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 14:35:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Date: Fri, 7 Dec 2007 20:54:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Shane <gnome42@gmail.com>, linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com> <20071207040219.e231cbc7.akpm@linux-foundation.org>
In-Reply-To: <20071207040219.e231cbc7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712072054.39603.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 7 of December 2007, Andrew Morton wrote:
> On Thu, 6 Dec 2007 23:45:58 -0500 Shane <gnome42@gmail.com> wrote:
> 
> > Hi,
> > 
> > The NFS crossmnt/nohide feature has been working beautifully
> > in 2.6.23. NFS in general has been really good in 2.6.23. Thanks!
> > 
> > However, starting in  2.6.24-rc3-git4, I immediately get 'NFS Stale
> > file handle' messages for any accesses to the NFS crossmnt'ed
> > volumes. Regular NFS mounts are fine but the crossmnt'ed
> > subdirs return only that error message.
> > 
> > 2.6.24-rc3-git1 is last known good kernel. The problem also exists
> > with the latest snap 2.6.24-rc4-git4. NFS server is 2.6.23-rc9 and
> > is unchanged.
> 
> hm, there have been no nfs changes since 2.6.24-rc4.
> 
> > It is easily reproducible here, hopefully for the person who
> > knows how to debug it too :)
> > 
> 
> I guess a full set of the commands which you typed to reproduce this would
> help.
> 
> Rafael, please add to the post-2.6.23 regression list?

Added, http://bugzilla.kernel.org/show_bug.cgi?id=9522 .

> (If there's any room left).

There is, but not much.

Thanks,
Rafael
