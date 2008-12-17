Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758669AbYLQCWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbYLQCWQ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 21:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYLQCV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 21:21:58 -0500
Received: from solo.fdn.fr ([80.67.169.19]:57925 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbYLQCV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 21:21:57 -0500
X-Greylist: delayed 1550 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2008 21:21:56 EST
Date: Wed, 17 Dec 2008 02:56:01 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: William Cohen <wcohen@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
Message-ID: <20081217015601.GE5147@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
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
References: <20081214212829.GA9435@elte.hu> <494807D2.3060808@redhat.com> <87prjr1scl.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87prjr1scl.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen, le Wed 17 Dec 2008 02:51:54 +0100, a écrit :
> William Cohen <wcohen@redhat.com> writes:
> > PERF_COUNT_CACHE_REFERENCES and PERF_COUNT_CACHE_MISSES are not single
> > monolitic events on many processors. There are multiple cache
> > levels. The L1 cache most processors have separate instruction and
> > data caches and require multiple counters to implement. Would these
> > refer to the last level of cache before memory and just be used to
> > compute the hit/miss rate for that last level? Some processors in the
> > same family have L2 and some processors have L3 cache. The setup code
> > would need to distinguish between these processor variants.
> 
> The difference between L1 and L3 caches can be huge (in some cases
> two orders of magnitude). With that I'm not sure a single cache
> miss/hit event even makes any sense.

Confirmed.  I have a code for which I'd like to know whether it fits
into at least L2 or even L1.

Samuel
