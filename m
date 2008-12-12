Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbYLLRNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbYLLRNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 12:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbYLLRN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 12:13:28 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:17466
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754101AbYLLRN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 12:13:27 -0500
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Dec 2008 12:13:27 EST
X-IronPort-AV: E=Sophos;i="4.36,211,1228086000"; 
   d="scan'208";a="32578673"
Date: Fri, 12 Dec 2008 18:03:36 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vince Weaver <vince@deater.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
Message-ID: <20081212170336.GJ5413@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Vince Weaver <vince@deater.net>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephane Eranian <eranian@googlemail.com>,
	Eric Dumazet <dada1@cosmosbay.com>,
	Robert Richter <robert.richter@amd.com>,
	Arjan van de Veen <arjan@infradead.org>,
	Peter Anvin <hpa@zytor.com>, Paul Mackerras <paulus@samba.org>,
	"David S. Miller" <davem@davemloft.net>
References: <20081211155230.GA4230@elte.hu> <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy> <1229070345.12883.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1229070345.12883.12.camel@twins>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra, le Fri 12 Dec 2008 09:25:45 +0100, a écrit :
> On Thu, 2008-12-11 at 13:02 -0500, Vince Weaver wrote:
> > Also, my primary method of using counters is total aggregate count for a 
> > single user-space process. 
> 
> Process, as in single thread, or multi-threaded? I'll assume
> single-thread.

BTW, just to make sure it is taken into account (I haven't followed the
thread up to here, just saw a "pid_t" somwhere that alarmed me): for our
uses, we _do_ need per-kernelthread counters.

Samuel
