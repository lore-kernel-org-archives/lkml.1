Return-Path: <linux-kernel-owner+w=401wt.eu-S1761062AbYDPCq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761062AbYDPCq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 22:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYDPCqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 22:46:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbYDPCqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 22:46:50 -0400
Date: Tue, 15 Apr 2008 19:45:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
In-Reply-To: <20080416003449.GA26633@elte.hu>
Message-ID: <alpine.LFD.1.00.0804151942550.2879@woody.linux-foundation.org>
References: <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org> <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com> <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
 <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi> <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org> <20080416000356.GA24737@elte.hu> <20080416003449.GA26633@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Apr 2008, Ingo Molnar wrote:
> 
> small addendum to the changelog:

Ok, you didn't make that addendum to your second version, so I added it 
myself.

Anyway, good job. I've pushed this out, and will let this simmer at least 
overnight to see if there are any brown-paper-bag issues (either with this 
or with some last changes from Andrew), but I'm happy, and I think I'll do 
the real 2.6.25 tomorrow.

		Linus
