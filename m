Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbYBFTjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbYBFTjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbYBFTjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:39:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43159 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755743AbYBFTje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:39:34 -0500
Date: Wed, 6 Feb 2008 11:37:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: mpm@selenic.com, bunk@kernel.org, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: blackfin compile error
Message-Id: <20080206113734.511473b0.akpm@linux-foundation.org>
In-Reply-To: <200802061412.50675.rgetz@blackfin.uclinux.org>
References: <20080206151830.GI505@cs181133002.pp.htv.fi>
	<1202315015.17934.242.camel@cinder.waste.org>
	<200802061412.50675.rgetz@blackfin.uclinux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 14:12:50 -0500
Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> On Wed 6 Feb 2008 11:23, Matt Mackall pondered:
> > 
> > On Wed, 2008-02-06 at 17:18 +0200, Adrian Bunk wrote:
> > > Commit 698dd4ba6b12e34e1e432c944c01478c0b2cd773 broke blackfin:
> > > 
> > > <--  snip  -->
> > > 
> > > ...
> > >   CC      mm/vmscan.o
> > > In file included from 
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/vmscan.c:44:
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h: In function 'is_swap_pte':
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_none'
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_present'
> > > make[2]: *** [mm/vmscan.o] Error 1
> > 
> > This suggests that no one's tried to compile -mm on Blackfin since
> > before September, I think.
> 
> Or any other nommu arch's either, since looking at the include files, FRV
> (when configured as noMMU) and m68knommu does not include it either...

sh is the only nommu arch which I test-compile for.

The world would be a better place if arch maintainers (or their helpers)
were to build and test -mm once a month or so.
