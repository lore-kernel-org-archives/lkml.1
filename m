Return-Path: <linux-kernel-owner+w=401wt.eu-S1763197AbXEVAb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763197AbXEVAb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbXEVAbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:31:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42150 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbXEVAbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:31:48 -0400
X-Greylist: delayed 64999 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2007 20:31:48 EDT
Date: Tue, 22 May 2007 09:30:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: ak@suse.de, dada1@cosmosbay.com, wli@holomorphy.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-Id: <20070522093050.0320d092.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0705211006550.26282@schroedinger.engr.sgi.com>
References: <20070518040854.GA15654@wotan.suse.de>
	<Pine.LNX.4.64.0705191121480.17008@schroedinger.engr.sgi.com>
	<464FCA28.9040009@cosmosbay.com>
	<200705201456.26283.ak@suse.de>
	<Pine.LNX.4.64.0705211006550.26282@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 10:08:06 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Sun, 20 May 2007, Andi Kleen wrote:
> 
> > Besides with the scarcity of pageflags it might make sense to do "64 bit only"
> > flags at some point.
> 
> There is no scarcity of page flags. There is
> 
> 1. Hoarding by Andrew
> 
> 2. Waste by Sparsemem (section flags no longer necessary with
>    virtual memmap)

For i386(32bit arch), there is not enough space for vmemmap.
For 64bit arch, page flags are not exhausted yet.

-Kame


