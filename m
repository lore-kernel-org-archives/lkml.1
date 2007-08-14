Return-Path: <linux-kernel-owner+w=401wt.eu-S935859AbXHNV43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935859AbXHNV43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbXHNVhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:37:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35869 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932808AbXHNVha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:37:30 -0400
Date: Tue, 14 Aug 2007 14:37:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
In-Reply-To: <20070814212955.GC23308@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0708141436380.31693@schroedinger.engr.sgi.com>
References: <20070814153021.446917377@sgi.com> <20070814153501.766137366@sgi.com>
 <p73vebhnauo.fsf@bingen.suse.de> <Pine.LNX.4.64.0708141209270.29498@schroedinger.engr.sgi.com>
 <20070814203329.GA22202@one.firstfloor.org>
 <Pine.LNX.4.64.0708141341120.31513@schroedinger.engr.sgi.com>
 <20070814204454.GC22202@one.firstfloor.org>
 <Pine.LNX.4.64.0708141414260.31693@schroedinger.engr.sgi.com>
 <20070814212355.GA23308@one.firstfloor.org>
 <Pine.LNX.4.64.0708141425000.31693@schroedinger.engr.sgi.com>
 <20070814212955.GC23308@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> > We already have such a flag in the zone structure
> 
> Zone structure is not strictly CPU local so it's broader
> than needed. But it might work.

We could convert this into a per cpu array?

But that still creates lots of overhead each time we take the lru lock!

