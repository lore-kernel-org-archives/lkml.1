Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYDLEXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYDLEXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 00:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYDLEXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 00:23:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbYDLEXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 00:23:04 -0400
Date: Fri, 11 Apr 2008 21:22:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm2
Message-Id: <20080411212222.b3c1177e.akpm@linux-foundation.org>
In-Reply-To: <20080411134036.GB3821@cs181133002.pp.htv.fi>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
	<20080411134036.GB3821@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 16:40:36 +0300 Adrian Bunk <bunk@kernel.org> wrote:

> On Thu, Apr 10, 2008 at 08:33:54PM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.25-rc8-mm1:
> >...
> > +ext4-is-busted-on-m68k.patch
> > 
> >  ext4 doesn't build on m68k
> >...
> 
> Is this due to the generic_find_next_le_bit compile error I reported as 
> 2.6.25 regression (there seems to be some discussion recently how to 
> fix it - hopefully for 2.6.25) or is there even more breakage in -mm?

Yes, it's the bitops screwup.

I saw some related linux-ext4 email float past yesterday, so something
might be happening.

