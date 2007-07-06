Return-Path: <linux-kernel-owner+w=401wt.eu-S1764048AbXGFSN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764048AbXGFSN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 14:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761973AbXGFSNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 14:13:21 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52861 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761940AbXGFSNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 14:13:20 -0400
Date: Fri, 6 Jul 2007 20:13:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mm/vmstat.c: possible cleanups
Message-ID: <20070706181350.GO3492@stusta.de>
References: <20070705232345.GG3492@stusta.de> <Pine.LNX.4.64.0707061048310.30575@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707061048310.30575@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 10:49:02AM -0700, Christoph Lameter wrote:
> On Fri, 6 Jul 2007, Adrian Bunk wrote:
> 
> > This patch contains the following possible cleanups:
> > - make the needlessly global setup_vmstat() static
> 
> Ok.
> 
> > - #if 0 the unused refresh_vm_stats()
> 
> Hmmm... This may be needed by the cpu idle code to update the vm stats 
> before going idle.

Since 1 year it's making the kernel image larger without having a single 
user.

And if it will one day get a user, removing the #if 0 will be trivial.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

