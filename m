Return-Path: <linux-kernel-owner+w=401wt.eu-S1765946AbYDOVWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765946AbYDOVWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYDOVVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:21:53 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52284 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753158AbYDOVVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:21:52 -0400
Date: Tue, 15 Apr 2008 14:21:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       travis@sgi.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
In-Reply-To: <20080415211953.GA4243@elte.hu>
Message-ID: <Pine.LNX.4.64.0804151420430.3252@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
 <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
 <20080415201734.GA25628@elte.hu> <20080415202805.GA26880@elte.hu>
 <20080415203405.GA27958@elte.hu> <20080415204208.GA30432@elte.hu>
 <Pine.LNX.4.64.0804151344340.1785@schroedinger.engr.sgi.com>
 <20080415205820.GC31645@elte.hu> <Pine.LNX.4.64.0804151405120.3252@schroedinger.engr.sgi.com>
 <20080415211953.GA4243@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008, Ingo Molnar wrote:

> what's the best way to artificially increase the size of the allocated 
> per cpu area? (say double it)

Add a big  per cpu declaration?

static DEFINE_PER_CPU(char, dummy)[10000];


