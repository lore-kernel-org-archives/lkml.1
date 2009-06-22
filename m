Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbZFVUk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbZFVUk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZFVUkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:40:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50983 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbZFVUkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:40:36 -0400
Date: Mon, 22 Jun 2009 22:40:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marco <marco.stornelli@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>, Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090622204031.GA24236@elf.ucw.cz>
References: <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com> <20090621064040.GC1656@ucw.cz> <4A3E6F28.4090404@gmail.com> <20090621205245.GC3254@elf.ucw.cz> <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com> <20090622172003.GB21149@elf.ucw.cz> <4A3FBFF0.40006@am.sony.com> <20090622173704.GC21299@elf.ucw.cz> <4A3FC84A.6060608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3FC84A.6060608@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-22 20:07:06, Marco wrote:
> Pavel Machek wrote:
> > On Mon 2009-06-22 10:31:28, Tim Bird wrote:
> >> Pavel Machek wrote:
> >>>>> How do you handle hard-links, then?
> >>>> Indeed hard-links are not supported :) Due to the design of this fs
> >>>> there are some limitations explained in the documentation as not
> >>>> hard-link, only private memory mapping and so on. However this
> >>>> limitations don't limit the fs itself because you must consider the
> >>>> special goal of this fs.
> >>> I did not see that in the changelog. If it is not general purpose
> >>> filesystem, it is lot less interesting.
> >> PRAMFS is not a general purpose filesystem. Please read
> >> the introductory post to this thread, or look at
> >> http://pramfs.sourceforge.net/ for more information.
> > 
> > Yeah, I seen that. It directly contradicts what you say.
> > 
> 
> I don't think, I think it's very clear:
> 
> "In summary, PRAMFS is a light-weight, full-featured, and
> space-efficient special filesystem that is ideal for systems with a

Except that it is not full-featured. No hardlinks. (What about ACLs, etc?)

> block of fast non-volatile RAM that need to access data on it using a
> standard filesytem interface."

Turns a block of fast RAM into 13MB/sec disk. Hmm. I believe you are
better with ext2.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
