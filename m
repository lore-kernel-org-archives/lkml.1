Return-Path: <linux-kernel-owner+w=401wt.eu-S933121AbZFLJn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbZFLJn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbZFLJnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:43:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39432 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbZFLJnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:43:16 -0400
Subject: Re: linux-next: origin tree build failure
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <1244799197.7172.106.camel@pasglop>
References: <20090612102427.32582baa.sfr@canb.auug.org.au>
	 <1244768406.7172.1.camel@pasglop>  <20090612092054.GB32052@elte.hu>
	 <1244799197.7172.106.camel@pasglop>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 11:43:06 +0200
Message-Id: <1244799786.6691.1133.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 19:33 +1000, Benjamin Herrenschmidt wrote:
> We should at least -try- to follow the
> process we've defined, don't you think ?

So you're saying -next should include whole new subsystems even though
its not clear they will be merged?

That'll invariably create the opposite case where a tree doesn't get
pulled and breaks bits due to its absence.

-next does a great job of sorting the existing subsystem trees, but I
don't think its Stephens job to decide if things will get merged.

Therefore when things are in limbo (there was no definite ACK from Linus
on perf counters) both inclusion and exclusion from -next can lead to
trouble.


