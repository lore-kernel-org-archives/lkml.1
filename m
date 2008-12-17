Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759467AbYLQJG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbYLQJG4 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYLQJGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:06:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53985 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYLQJGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:06:34 -0500
Date: Wed, 17 Dec 2008 10:18:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nils Smeds <nils.smeds@gmail.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Andi Kleen <andi@firstfloor.org>, William Cohen <wcohen@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Robert Richter <robert.richter@amd.com>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Stephane Eranian <eranian@googlemail.com>,
        Paul Mackerras <paulus@samba.org>, Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        perfctr-devel@lists.sourceforge.net,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Perfctr-devel] [patch] Performance Counters for Linux, v4
Message-ID: <20081217091845.GC25779@one.firstfloor.org>
References: <20081214212829.GA9435@elte.hu> <494807D2.3060808@redhat.com> <87prjr1scl.fsf@basil.nowhere.org> <20081217015601.GE5147@const.famille.thibault.fr> <d484eb1f0812162357n7a851f2fncc0abaae9bd293a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d484eb1f0812162357n7a851f2fncc0abaae9bd293a4@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To make life easier for developers not interested in exact measuring, but in
> cross-platform development, PAPI has introduced "generic" events. These are
> documented not to be interpretable in a cross-platform manner - and
> typically consist of aggregation of a number of low-level architecture
> specific events. Instead a measure as PERF_COUNT_CACHE_REFERENCES tries to
> create an event set that is a "best effort" for the platform. Typically it
> would try to count read and write events to L1 and L2, but depending on the

The point was that L1 and L2/L3 behave so differently in practice
due to their latency/bandwidth differences (typically L1 is more like a 
slower register file while L3 is more like faster DRAM) that it's unclear
that any generic event not defining what it means is any useful.

I could see the point of generic FLC/LLC cache events perhaps,
but not of a single one lumping these two together.

But although with multi core it looks like 3 level hierarchies are
becoming more and more common and also more important to know
about.

-Andi

-- 
ak@linux.intel.com
