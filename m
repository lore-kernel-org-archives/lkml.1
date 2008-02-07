Return-Path: <linux-kernel-owner+w=401wt.eu-S935040AbYBGVbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935040AbYBGVbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYBGVbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:31:01 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:30256 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbYBGVa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:30:59 -0500
X-IronPort-AV: E=Sophos;i="4.25,317,1199682000"; 
   d="scan'208";a="48113097"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: blackfin compile error
Date: Thu, 7 Feb 2008 16:32:24 -0500
User-Agent: KMail/1.9.5
Cc: mpm@selenic.com, bunk@kernel.org, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
References: <20080206151830.GI505@cs181133002.pp.htv.fi> <200802061412.50675.rgetz@blackfin.uclinux.org> <20080206113734.511473b0.akpm@linux-foundation.org>
In-Reply-To: <20080206113734.511473b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071632.25193.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 07 Feb 2008 21:30:57.0763 (UTC) FILETIME=[BA2C2B30:01C869D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 6 Feb 2008 14:37, Andrew Morton pondered:
> On Wed, 6 Feb 2008 14:12:50 -0500
> Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> 
> > On Wed 6 Feb 2008 11:23, Matt Mackall pondered:
> > > 
> > > On Wed, 2008-02-06 at 17:18 +0200, Adrian Bunk wrote:
> > > > Commit 698dd4ba6b12e34e1e432c944c01478c0b2cd773 broke blackfin:
> > > > 
> > > > <--  snip  -->
> > > > 
> > > > ...
> > > >   CC      mm/vmscan.o
> > > > In file included from 
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/vmscan.c:44:
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h: In function 'is_swap_pte':
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_none'
> > > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_present'
> > > > make[2]: *** [mm/vmscan.o] Error 1
> > > 
> > > This suggests that no one's tried to compile -mm on Blackfin since
> > > before September, I think.
> > 
> > Or any other nommu arch's either, since looking at the include files,
> > FRV (when configured as noMMU) and m68knommu does not include it either...
> 
> sh is the only nommu arch which I test-compile for.
> 
> The world would be a better place if arch maintainers (or their helpers)
> were to build and test -mm once a month or so.

OK - now that we have that fixed (Mike/Bryan will do this on the mm tree and
at least fix up compile issues as soon as we notice) - how do we want to fix
this specific issue?

Add the missing entries into include/asm-xxxxx/pgtable.h or wrap the callers
in ifdefs?

-Robin

-Robin
