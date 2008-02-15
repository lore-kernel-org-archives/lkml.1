Return-Path: <linux-kernel-owner+w=401wt.eu-S1764293AbYBOLgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764293AbYBOLgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 06:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYBOLgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 06:36:15 -0500
Received: from aun.it.uu.se ([130.238.12.36]:62374 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYBOLgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 06:36:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18357.30971.334517.722985@harpo.it.uu.se>
Date: Fri, 15 Feb 2008 12:35:23 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [PATCH] Make sysctl a separate filesystem
In-Reply-To: <p73ejbe1ook.fsf@bingen.suse.de>
References: <47B56BF2.4020600@openvz.org>
	<p73ejbe1ook.fsf@bingen.suse.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen writes:
 > Pavel Emelyanov <xemul@openvz.org> writes:
 > >    this subdir;
 > > 3. sysctl inodes are now smaller than the procfs ones.
 > 
 > That's always a good thing.
 > 
 > > Note: update your initscripts to mount sysctl filesystem 
 > > right after the proc is mounted in order not to lose your
 > > /etc/sysctl.conf configuration (and optionally fstab).
 > 
 > That will break about everybody's init scripts I suspect.
 > 
 > I think you would need to go through some deprecation
 > period for this at least, with printks warning people
 > to fix their init scripts.
 > 
 > Or better find some way to do the mount automatically.

Doing it automatically is the only acceptable way, IMO.
