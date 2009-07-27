Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZG0Rwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZG0Rwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZG0Rwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:52:34 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:52299 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZG0Rwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:52:34 -0400
Date: Mon, 27 Jul 2009 21:52:25 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jamie Lokier <jamie@shareable.org>
Cc: Eric Paris <eparis@redhat.com>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, jengelh@medozas.de, aviro@redhat.com,
       mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090727175225.GA27999@ioremap.net>
References: <1248466429.3567.82.camel@localhost> <alpine.DEB.1.10.0907241340580.28013@asgard.lang.hm> <1248469278.3567.88.camel@localhost> <20090724214401.GJ27755@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724214401.GJ27755@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, Jul 24, 2009 at 10:44:01PM +0100, Jamie Lokier (jamie@shareable.org) wrote:
> > No, I will NOT EVER pass a pathname.  Period.  End of story.  I stated
> > the if userspace wants to deal with pathnames (and they understand the
> > system setup well enough to know if pathnames even make sense to them)
> > they can use readlink(2) on /proc/self/fd
> 
> That makes sense.
> 
> In most cases where events trigger userspace cache or index updates,
> userspace already has enough information to calculate the path (and
> any derived data) from the inode number (in the case of non-hard-link
> files) or from the inode number of the parent directory and the name
> (not full path).

Except that rlimits may forbid to open new file descriptor while queue
length is enough to put another event with the full or partial path
name.

I will read initial mail next, but if it is not described there, how
rlimit problem is handled?

-- 
	Evgeniy Polyakov
