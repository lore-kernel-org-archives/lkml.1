Return-Path: <linux-kernel-owner+w=401wt.eu-S1762439AbYDOVm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762439AbYDOVm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932410AbYDOVmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:42:45 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36097 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932128AbYDOVmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:42:44 -0400
Date: Tue, 15 Apr 2008 14:42:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
In-Reply-To: <20080415212430.GA5467@elte.hu>
Message-ID: <Pine.LNX.4.64.0804151437300.3252@schroedinger.engr.sgi.com>
References: <20080415161532.GA15088@elte.hu>
 <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org>
 <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
 <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
 <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi>
 <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
 <20080415211359.GA1531@elte.hu> <20080415212430.GA5467@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008, Ingo Molnar wrote:

> btw., as i progress with that bisection effort, i triggered new crash 
> patterns, which lappen later during bootup:

It may help to run with slub_debug (or CONFIG_SLUB_DEBUG_ON) then to 
detect the corruption as early as possible. Only works if you get by 
kmem_cache_init() though. Should give us some informative dumps of what is 
exactly corrupted if it hits a slab object.
