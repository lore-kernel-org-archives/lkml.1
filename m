Return-Path: <linux-kernel-owner+w=401wt.eu-S935397AbYCEAK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935397AbYCEAK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbYCEAKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:10:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56015
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756551AbYCEAKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:10:04 -0500
Date: Tue, 04 Mar 2008 16:10:03 -0800 (PST)
Message-Id: <20080304.161003.129716254.davem@davemloft.net>
To: npiggin@suse.de
Cc: clameter@sgi.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       yanmin_zhang@linux.intel.com, dada1@cosmosbay.com
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080305000637.GA1510@wotan.suse.de>
References: <20080303201701.GF8974@wotan.suse.de>
	<Pine.LNX.4.64.0803031315160.4131@schroedinger.engr.sgi.com>
	<20080305000637.GA1510@wotan.suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Wed, 5 Mar 2008 01:06:37 +0100

> On Mon, Mar 03, 2008 at 01:16:44PM -0800, Christoph Lameter wrote:
> > On Mon, 3 Mar 2008, Nick Piggin wrote:
> > 
> > > > HWCACHE_ALIGN means that you want the object to be aligned at 
> > > > cacheline boundaries for optimization. Why does crossing cacheline 
> > > > boundaries matter in this case?
> > > 
> > > No, HWCACHE_ALIGN means that you want the object not to cross cacheline
> > > boundaries for at least cache_line_size() bytes. You invented new
> > 
> > Interesting new definition....
> 
> Huh?? It is not a new definition, it is exactly what SLAB does. And
> then you go and do something different and claim that you follow
> what slab does.

I completely agree with Nick.
