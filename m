Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbYDOXcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbYDOXcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 19:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYDOXcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 19:32:12 -0400
Received: from relay2.sgi.com ([192.48.171.30]:55270 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751304AbYDOXcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 19:32:11 -0400
Date: Tue, 15 Apr 2008 16:32:03 -0700 (PDT)
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
In-Reply-To: <20080415232711.GA22679@elte.hu>
Message-ID: <Pine.LNX.4.64.0804151628420.5108@schroedinger.engr.sgi.com>
References: <20080415204025.GA29784@elte.hu>
 <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
 <20080415211359.GA1531@elte.hu> <20080415212430.GA5467@elte.hu>
 <Pine.LNX.4.64.0804151437300.3252@schroedinger.engr.sgi.com>
 <20080415215504.GA9066@elte.hu> <Pine.LNX.4.64.0804151455520.4038@schroedinger.engr.sgi.com>
 <20080415221314.GA12094@elte.hu> <Pine.LNX.4.64.0804151517530.4038@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0804151609510.5018@schroedinger.engr.sgi.com>
 <20080415232711.GA22679@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008, Ingo Molnar wrote:

> ... in the thread i've already explained that it's because on PAE we use 
> 1GB sparse chunks (shift 30) which masks the bug.

Ahh. Right. That is the same situation as HIGHMEM_64G. I was able to 
enable PAE without HIGHMEM_64G. Thought that would keep things as is.
