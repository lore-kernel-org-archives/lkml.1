Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbXFTSQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbXFTSQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbXFTSQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:16:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41789 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbXFTSQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:16:29 -0400
Subject: Re: Change in default vm_dirty_ratio
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, tim.c.chen@linux.intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.98.0706201015370.3593@woody.linux-foundation.org>
References: <1182201271.4883.22.camel@localhost.localdomain>
	 <20070618164711.9de1c38e.akpm@linux-foundation.org>
	 <20070620042434.GC12096@redhat.com>
	 <20070619214407.dfff0ca6.akpm@linux-foundation.org>
	 <1182328536.21117.24.camel@twins>
	 <alpine.LFD.0.98.0706201015370.3593@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 20 Jun 2007 11:12:53 -0700
Message-Id: <1182363174.2701.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 10:17 -0700, Linus Torvalds wrote:
> 
> On Wed, 20 Jun 2007, Peter Zijlstra wrote:
> > 
> > Building on the per BDI patches, how about integrating feedback from the
> > full-ness of device queues. That is, when we are happily doing IO and we
> > cannot possibly saturate the active devices (as measured by their queue
> > never reaching 75%?) then we can safely increase the total dirty limit.
> 
> The really annoying things are the one-off things. You've been happily 
> working for a while (never even being _close_ to saturatign any IO 
> queues), and then you untar a large tree.
> 
> If the kernel now let's you dirty lots of memory, you'll have a very 
> unpleasant experience.


maybe that needs to be fixed? If you stopped dirtying after the initial
bump.. is there a reason for the kernel to dump all that data to the
disk in such a way that it disturbs interactive users?

so the question maybe is.. is the vm tunable the cause or the symptom of
the bad experience?


