Return-Path: <linux-kernel-owner+w=401wt.eu-S1763462AbYBVJxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763462AbYBVJxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934714AbYBVJwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:52:36 -0500
Received: from aun.it.uu.se ([130.238.12.36]:35536 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934667AbYBVJwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:52:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18366.39762.445478.210383@alkaid.it.uu.se>
Date: Fri, 22 Feb 2008 10:52:18 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [PATCH] Make sysctl a separate filesystem
In-Reply-To: <20080222012530.GD27894@ZenIV.linux.org.uk>
References: <47B56BF2.4020600@openvz.org>
	<p73ejbe1ook.fsf@bingen.suse.de>
	<18357.30971.334517.722985@harpo.it.uu.se>
	<20080222012530.GD27894@ZenIV.linux.org.uk>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro writes:
 > On Fri, Feb 15, 2008 at 12:35:23PM +0100, Mikael Pettersson wrote:
 > > Andi Kleen writes:
 > >  > Pavel Emelyanov <xemul@openvz.org> writes:
 > >  > >    this subdir;
 > >  > > 3. sysctl inodes are now smaller than the procfs ones.
 > >  > 
 > >  > That's always a good thing.
 > >  > 
 > >  > > Note: update your initscripts to mount sysctl filesystem 
 > >  > > right after the proc is mounted in order not to lose your
 > >  > > /etc/sysctl.conf configuration (and optionally fstab).
 > >  > 
 > >  > That will break about everybody's init scripts I suspect.
 > >  > 
 > >  > I think you would need to go through some deprecation
 > >  > period for this at least, with printks warning people
 > >  > to fix their init scripts.
 > >  > 
 > >  > Or better find some way to do the mount automatically.
 > > 
 > > Doing it automatically is the only acceptable way, IMO.
 > 
 > When and where?

I don't really care, as long as existing user-space doesn't get broken.
