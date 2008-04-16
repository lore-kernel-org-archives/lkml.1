Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbYDPAqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbYDPAqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYDPAqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:46:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55392 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752917AbYDPAqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:46:47 -0400
Date: Tue, 15 Apr 2008 17:46:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
In-Reply-To: <20080416004430.GA26928@elte.hu>
Message-ID: <Pine.LNX.4.64.0804151745440.6876@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
 <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
 <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi>
 <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
 <20080416000356.GA24737@elte.hu> <20080416001816.GA26295@elte.hu>
 <86802c440804151732j519a541t9d8e4f6b49a53313@mail.gmail.com>
 <20080416004430.GA26928@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008, Ingo Molnar wrote:

> this is the only call to memory_present() we do in 32-bit arch setup, so 
> it's required.

We could clip there if SPARSEMEM is configured. I wonder if this affects 
other platforms that need HIGHMEM support?
