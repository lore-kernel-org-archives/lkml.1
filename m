Return-Path: <linux-kernel-owner+w=401wt.eu-S1763390AbYBOMoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763390AbYBOMoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYBOMoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:44:37 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:59920 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbYBOMog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:44:36 -0500
Date: Fri, 15 Feb 2008 13:44:35 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mikael Pettersson <mikpe@it.uu.se>
cc: Andi Kleen <andi@firstfloor.org>, Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [PATCH] Make sysctl a separate filesystem
In-Reply-To: <18357.30971.334517.722985@harpo.it.uu.se>
Message-ID: <Pine.LNX.4.64.0802151343330.30301@fbirervta.pbzchgretzou.qr>
References: <47B56BF2.4020600@openvz.org> <p73ejbe1ook.fsf@bingen.suse.de>
 <18357.30971.334517.722985@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 15 2008 12:35, Mikael Pettersson wrote:
>Andi Kleen writes:
> > Pavel Emelyanov <xemul@openvz.org> writes:
> > >    this subdir;
> > > 3. sysctl inodes are now smaller than the procfs ones.
> > 
> > That's always a good thing.
> > 
> > > Note: update your initscripts to mount sysctl filesystem 
> > > right after the proc is mounted in order not to lose your
> > > /etc/sysctl.conf configuration (and optionally fstab).
> > 
> > That will break about everybody's init scripts I suspect.
> > 
> > I think you would need to go through some deprecation
> > period for this at least, with printks warning people
> > to fix their init scripts.
> > 
> > Or better find some way to do the mount automatically.
>
>Doing it automatically is the only acceptable way, IMO.

For time being only.

The kernel (currently) only auto-mounts invisible filesystems.
