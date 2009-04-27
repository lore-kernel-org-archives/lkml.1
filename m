Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZD0MOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZD0MOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZD0MNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:13:51 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:58104 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZD0MNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:13:51 -0400
Date: Mon, 27 Apr 2009 14:15:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: monstr@monstr.eu, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
Message-ID: <20090427121556.GA9469@uranus.ravnborg.org>
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <20090427113030.GA3681@infradead.org> <49F59A6E.9080900@monstr.eu> <200904271357.01681.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904271357.01681.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 01:57:00PM +0200, Arnd Bergmann wrote:
> On Monday 27 April 2009, Michal Simek wrote:
> > Christoph Hellwig wrote:
> 
> > > Given that microblaze only got merged in the 2.6.30 window I would
> > > suggest fixing up the nommu variant.
> > 
> > ok. Let's do it.
> > Here are stats structures from xtensa.
> > 
> > Arnd: Is it ok for asm-generic?
> 
> I carry a (not cleaned up) tree with changes in my playground
> (git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git)
> as branch generic-microblaze, where I try to use generic
> headers for everything. See below for my version of stat.h.
> In particular, it uses 64 bit st_size and st_blocks, but 32 bit
> time fields. It also defines struct stat to be identical to
> struct stat64 on 64 bit systems. 32 bit systems should only
> provide the stat64 syscalls, so the shorter types in struct
> stat do not hurt.

Why not use __u64/__u32 (and s32/s64 where appropriate)?
Historical baggage or a techncal reason?

	Sam
