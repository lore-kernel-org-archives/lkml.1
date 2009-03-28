Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZC1BaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZC1BaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 21:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZC1BaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 21:30:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:34075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbZC1BaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 21:30:05 -0400
Subject: Re: DRM lock ordering fix series
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Anholt <eric@anholt.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <1238201922.4039.403.camel@laptop>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <87ocvnmhqx.fsf@basil.nowhere.org>
	 <1238170767.8275.2397.camel@gaiman.anholt.net>
	 <1238171805.8275.2434.camel@gaiman.anholt.net>
	 <20090327181018.GC11935@one.firstfloor.org>
	 <1238184629.625.44.camel@gaiman.anholt.net>
	 <1238201922.4039.403.camel@laptop>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 02:29:59 +0100
Message-Id: <1238203799.4039.437.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-28 at 01:58 +0100, Peter Zijlstra wrote:

> > OK.  I'm not too excited here -- 10% of 2% of the CPU time doesn't get
> > me to the 10% loss that the slow path added up to.  Most of the cost is
> > in k{un,}map_atomic of the returned pages.  
> 
> Also note that doing large gup() with gup_fast() will be undesirable due
> to it disabling IRQs. So iterating say several MB worth of pages will
> hurt like crazy. Currently all gup_fast() users do a single page lookup.

Also, what's this weird facination with 32bit, can you even buy a 32bit
only cpu these days?

