Return-Path: <linux-kernel-owner+w=401wt.eu-S1760649AbXJYWnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbXJYWnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760268AbXJYWnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:43:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59731 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760224AbXJYWnF (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:43:05 -0400
Date: Fri, 26 Oct 2007 08:42:35 +1000
From: David Chinner <dgc@sgi.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: staubach@redhat.com, akpm@linux-foundation.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] VFS: new fgetattr() file operation
Message-ID: <20071025224235.GZ995458@sgi.com>
References: <E1Iketp-0005dr-00@dorka.pomaz.szeredi.hu> <471F4254.9040206@redhat.com> <E1IkgW1-0005i0-00@dorka.pomaz.szeredi.hu> <471F5EA2.8060203@redhat.com> <E1Iki8O-0005nu-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Iki8O-0005nu-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 05:27:04PM +0200, Miklos Szeredi wrote:
> > >> Wouldn't you be better off by attempting to implement an "open
> > >> by ino" operation and an operation to get the generation count
> > >> for the file and then modifying the network protocol of interest
> > >> to use these as identifiers for the file to be manipulated?
> > >>     
> > >
> > > You mean an "open by inode" on the userspace API?  My guess, it
> > > wouldn't get very far.
> > 
> > This isn't a new idea and has been implemented on a variety of
> > different systems.
> 
> Like?

XFS.

'man open_by_handle'

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
