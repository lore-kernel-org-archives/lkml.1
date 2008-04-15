Return-Path: <linux-kernel-owner+w=401wt.eu-S1762229AbYDOUuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762229AbYDOUuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYDOUuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:50:12 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38086 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752864AbYDOUuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:50:11 -0400
Date: Tue, 15 Apr 2008 13:50:10 -0700 (PDT)
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
In-Reply-To: <20080415204208.GA30432@elte.hu>
Message-ID: <Pine.LNX.4.64.0804151344340.1785@schroedinger.engr.sgi.com>
References: <20080415062534.GA9172@elte.hu>
 <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org>
 <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org>
 <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
 <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
 <20080415201734.GA25628@elte.hu> <20080415202805.GA26880@elte.hu>
 <20080415203405.GA27958@elte.hu> <20080415204208.GA30432@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vexing. The failure in the slabs suggests that no lowmem pages were freed 
during the walk of the bootmem bitmaps. Could you call show_mem before 
kmem_cache_init() runs?
