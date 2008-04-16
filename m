Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbYDPAKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbYDPAKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYDPAKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:10:10 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52993 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753868AbYDPAKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:10:09 -0400
Date: Tue, 15 Apr 2008 17:10:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
In-Reply-To: <20080416000356.GA24737@elte.hu>
Message-ID: <Pine.LNX.4.64.0804151709070.5705@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org>
 <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org>
 <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
 <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
 <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi>
 <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
 <20080416000356.GA24737@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes that fixes it here too. And the corruption that I saw of slab 
variables is explained by your analysis. Thanks!

Tested-by: Christoph Lameter <clameter@sgi.com>
