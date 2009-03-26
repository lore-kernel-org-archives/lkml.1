Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbZCZQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbZCZQeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbZCZQeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:34:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbZCZQeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:34:01 -0400
Date: Thu, 26 Mar 2009 09:24:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, mingo@elte.hu, tytso@mit.edu, jack@suse.cz,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, a.p.zijlstra@chello.nl,
       npiggin@suse.de, jens.axboe@oracle.com, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org, oleg@redhat.com,
       roland@redhat.com
Subject: Re: relatime: update once per day patches (was: ext3 IO latency
 measurements)
Message-Id: <20090326092454.b74e3f96.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0903260912270.3032@localhost.localdomain>
References: <20090325123744.GK23439@duck.suse.cz>
	<20090325150041.GM32307@mit.edu>
	<alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	<20090325185824.GO32307@mit.edu>
	<alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
	<20090325215137.GQ32307@mit.edu>
	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326113705.GV32307@mit.edu>
	<20090326140312.GB14822@elte.hu>
	<20090326140312.GB14822@elte.hu>
	<20090326073013.2fa83178.akpm@linux-foundation.org>
	<200903261632.42439.elendil@planet.nl>
	<20090326084733.156c4910.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903260912270.3032@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 09:14:28 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 26 Mar 2009, Andrew Morton wrote:
> > 
> > Hard-wiring a 24-hour interval into the core VFS for all mounted
> > filesystems is dumb.
> 
> Umm. 
> 
> I generally agree witht he "leave policy to user space" people, but this 
> is an area where (a) user space has shown itself to not get it right (ie 
> people don't do even the existing relatime because distros don't) and (b) 
> what's the alternative?
> 
> > I (and others) pointed out that it would be better to implement this as
> > a mount option.  That suggestion was met with varying sillinesses and
> > that is where things stand.
> 
> I'd suggest first just doing the 24 hour thing, and then, IF user space 
> actually ever gets its act together, and people care, and they _ask_ for a 
> mount option, that's when it's worth doing.
> 

We wouldn't normally just enable the new feature by default because it
changes kernel behaviour.  Userspace needs to be changed in some manner to
opt-in.  One way it's `mount -o remount', the other way it's a poke in
/proc.



