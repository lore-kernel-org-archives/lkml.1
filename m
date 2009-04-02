Return-Path: <linux-kernel-owner+w=401wt.eu-S935430AbZDBJQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935430AbZDBJQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934950AbZDBJN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:13:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59173 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934862AbZDBJN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:13:56 -0400
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <18900.33013.359312.694434@cargo.ozlabs.ibm.com>
References: <20090330170701.856843742@chello.nl>
	 <20090330171024.254266860@chello.nl>
	 <18897.46177.528910.51044@cargo.ozlabs.ibm.com>
	 <1238481552.28248.1384.camel@twins> <49D1C544.7020403@linux.vnet.ibm.com>
	 <18897.56973.324304.995540@cargo.ozlabs.ibm.com>
	 <1238508032.8530.278.camel@twins>
	 <18898.58399.957182.181124@drongo.ozlabs.ibm.com>
	 <1238572744.8530.2541.camel@twins> <49D3F7E4.7010308@linux.vnet.ibm.com>
	 <1238654631.8530.5361.camel@twins> <1238658096.8530.5480.camel@twins>
	 <18900.33013.359312.694434@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Apr 2009 11:14:51 +0200
Message-Id: <1238663691.8530.5678.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 20:10 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > Hmm, another idea:
> > 
> > struct perf_callchain_entry {
> >   __u32 total, hv, kernel, user;
> 
> That should work - and they could be u16's in fact.

Gah, I just send it out with u32. But yes, will change.
