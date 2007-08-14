Return-Path: <linux-kernel-owner+w=401wt.eu-S935612AbXHNVxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935612AbXHNVxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762970AbXHNVaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:30:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51076 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763592AbXHNV37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:29:59 -0400
Date: Tue, 14 Aug 2007 23:29:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
Message-ID: <20070814212955.GC23308@one.firstfloor.org>
References: <20070814153021.446917377@sgi.com> <20070814153501.766137366@sgi.com> <p73vebhnauo.fsf@bingen.suse.de> <Pine.LNX.4.64.0708141209270.29498@schroedinger.engr.sgi.com> <20070814203329.GA22202@one.firstfloor.org> <Pine.LNX.4.64.0708141341120.31513@schroedinger.engr.sgi.com> <20070814204454.GC22202@one.firstfloor.org> <Pine.LNX.4.64.0708141414260.31693@schroedinger.engr.sgi.com> <20070814212355.GA23308@one.firstfloor.org> <Pine.LNX.4.64.0708141425000.31693@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708141425000.31693@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 02:26:43PM -0700, Christoph Lameter wrote:
> On Tue, 14 Aug 2007, Andi Kleen wrote:
> 
> > > So every spinlock would have an array of chars sized to NR_CPUS and set 
> > > the flag when the lock is taken?
> > 
> > I was more thinking of a single per cpu flag for all of page reclaim
> > That keeps it also cache local.
> 
> We already have such a flag in the zone structure

Zone structure is not strictly CPU local so it's broader
than needed. But it might work.

-Andi
