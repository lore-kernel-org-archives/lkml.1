Return-Path: <linux-kernel-owner+w=401wt.eu-S1759914AbYABVRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914AbYABVRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbYABVRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:17:15 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39116 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091AbYABVRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:17:14 -0500
Date: Wed, 2 Jan 2008 23:16:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Diego Calleja <diegocg@gmail.com>
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Message-ID: <20080102211655.GC15898@does.not.exist>
References: <20080102013218.GO27566@does.not.exist> <20080102192629.28e67241.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080102192629.28e67241.diegocg@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 07:26:29PM +0100, Diego Calleja wrote:
> El Wed, 2 Jan 2008 03:32:18 +0200, Adrian Bunk <bunk@kernel.org> escribió:
> 
> > It might make sense to offer ext4 in -mm and even in early -rc kernels, 
> > but I've already seen people using ext4 simply because a stable kernel 
> > offered it - and that's definitely not intended.
> 
> But isn't that the whole purpose of having ext4 snapshots in the stable kernel - to
> allow people to try it?

ext4 has quite an unusual development model for kernel code, other 
code in the state of ext4 is usually only in -mm and not in stable 
kernels.

Stable kernels are mainly meant for usage, not for trying stuff.
And although I see a point in perhaps shipping some not-yet-perfect 
device drivers for otherwise unsupported hardware or some
not-yet-perfect filesystems required for accessing foreign
(non-Linux) filesystems, I don't see any point in offering a
WIP Linux-only filesystem in stable kernels.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

