Return-Path: <linux-kernel-owner+w=401wt.eu-S933316AbYBVBZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316AbYBVBZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYBVBZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:25:44 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37904 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYBVBZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:25:44 -0500
Date: Fri, 22 Feb 2008 01:25:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Andi Kleen <andi@firstfloor.org>, Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [PATCH] Make sysctl a separate filesystem
Message-ID: <20080222012530.GD27894@ZenIV.linux.org.uk>
References: <47B56BF2.4020600@openvz.org> <p73ejbe1ook.fsf@bingen.suse.de> <18357.30971.334517.722985@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18357.30971.334517.722985@harpo.it.uu.se>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 12:35:23PM +0100, Mikael Pettersson wrote:
> Andi Kleen writes:
>  > Pavel Emelyanov <xemul@openvz.org> writes:
>  > >    this subdir;
>  > > 3. sysctl inodes are now smaller than the procfs ones.
>  > 
>  > That's always a good thing.
>  > 
>  > > Note: update your initscripts to mount sysctl filesystem 
>  > > right after the proc is mounted in order not to lose your
>  > > /etc/sysctl.conf configuration (and optionally fstab).
>  > 
>  > That will break about everybody's init scripts I suspect.
>  > 
>  > I think you would need to go through some deprecation
>  > period for this at least, with printks warning people
>  > to fix their init scripts.
>  > 
>  > Or better find some way to do the mount automatically.
> 
> Doing it automatically is the only acceptable way, IMO.

When and where?
