Return-Path: <linux-kernel-owner+w=401wt.eu-S936798AbXFFWjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936798AbXFFWjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935293AbXFFWit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:38:49 -0400
Received: from canuck.infradead.org ([209.217.80.40]:45583 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935258AbXFFWis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:38:48 -0400
Date: Wed, 6 Jun 2007 15:30:31 -0700
From: Greg KH <greg@kroah.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Wright <chrisw@sous-sol.org>, sandeen@redhat.com, htejun@gmail.com,
       gregkh@suse.de, linux-kernel@vger.kernel.org, maneesh@in.ibm.com,
       akpm@linux-foundation.org, stable@kernel.org
Subject: Re: [stable] patch
	sysfs-store-sysfs-inode-nrs-in-s_ino-to-avoid-readdir-oopses.patch
	queued to -stable tree
Message-ID: <20070606223031.GA16147@kroah.com>
References: <46525648.8050807@sandeen.net> <20070606194950.D357EE83785@imap.suse.de> <20070606213543.GS3723@sequoia.sous-sol.org> <466728D6.30200@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466728D6.30200@sandeen.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 04:36:22PM -0500, Eric Sandeen wrote:
> Chris Wright wrote:
> > * gregkh@suse.de (gregkh@suse.de) wrote:
> >> From: Eric Sandeen <sandeen@sandeen.net>
> >> Subject: sysfs: store sysfs inode nrs in s_ino to avoid readdir oopses
> >>
> >> Backport of
> >> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/broken-out/gregkh-driver-sysfs-allocate-inode-number-using-ida.patch
> >>
> > 
> > I didn't put this into -stable queue because the ida version is not
> > upstream yet, so I don't think it's appropriate to backport it at this
> > point in time.
> 
> Well, my backport of Tejun's patch explicitly doesn't use ida for just
> that reason...
> 
> It uses a simple counter instead (which may give dup inode numbers, but
> I think we have that today, and at least this shouldn't oops...)

Ok, I'll pull it out as the number of people really seeing this in the
wild is so small that it's not worth it.

thanks,

greg k-h
