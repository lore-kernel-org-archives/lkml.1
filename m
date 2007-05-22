Return-Path: <linux-kernel-owner+w=401wt.eu-S1759716AbXEVA66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716AbXEVA66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbXEVA6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:58:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60306 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbXEVA6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:58:46 -0400
Date: Tue, 22 May 2007 09:58:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: ak@suse.de, dada1@cosmosbay.com, wli@holomorphy.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-Id: <20070522095836.c01263ba.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0705211737450.24160@schroedinger.engr.sgi.com>
References: <20070518040854.GA15654@wotan.suse.de>
	<Pine.LNX.4.64.0705191121480.17008@schroedinger.engr.sgi.com>
	<464FCA28.9040009@cosmosbay.com>
	<200705201456.26283.ak@suse.de>
	<Pine.LNX.4.64.0705211006550.26282@schroedinger.engr.sgi.com>
	<20070522093050.0320d092.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0705211737450.24160@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 17:38:58 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 22 May 2007, KAMEZAWA Hiroyuki wrote:
> 
> > For i386(32bit arch), there is not enough space for vmemmap.
> 
> I thought 32 bit would use flatmem? Is memory really sparse on 32 
> bit? Likely difficult due to lack of address space?
> 

Of course, i386 can use flatmem.

I am just afraid that memory hotplug is just for sprasemem.
But I also think we can add memory-hotplug for flatmem if necessary.
(I myself have no plan now. I wonder memory power-save-mode may be supported
 by chipsets.)

-Kame

