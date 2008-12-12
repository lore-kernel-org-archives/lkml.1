Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbYLLRMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbYLLRMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 12:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758119AbYLLRMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 12:12:00 -0500
Received: from viefep17-int.chello.at ([62.179.121.37]:65455 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758023AbYLLRL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 12:11:59 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] Performance Counters for Linux, v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Vince Weaver <vince@deater.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20081212170336.GJ5413@const.bordeaux.inria.fr>
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	 <1229070345.12883.12.camel@twins>
	 <20081212170336.GJ5413@const.bordeaux.inria.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Dec 2008 18:11:50 +0100
Message-Id: <1229101910.13566.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 18:03 +0100, Samuel Thibault wrote:
> Peter Zijlstra, le Fri 12 Dec 2008 09:25:45 +0100, a écrit :
> > On Thu, 2008-12-11 at 13:02 -0500, Vince Weaver wrote:
> > > Also, my primary method of using counters is total aggregate count for a 
> > > single user-space process. 
> > 
> > Process, as in single thread, or multi-threaded? I'll assume
> > single-thread.
> 
> BTW, just to make sure it is taken into account (I haven't followed the
> thread up to here, just saw a "pid_t" somwhere that alarmed me): for our
> uses, we _do_ need per-kernelthread counters.

Yes, counters are per task - not sure on the exact interface thingy
though - I guess it should be tid_t but glibc does a bit weird there or
something.

