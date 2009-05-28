Return-Path: <linux-kernel-owner+w=401wt.eu-S1762937AbZE1Qr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762937AbZE1Qr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbZE1Qrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:47:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60559 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbZE1Qru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:47:50 -0400
Subject: Re: comments on Performance Counters for Linux (PCL)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <1243527919.6645.75.camel@laptop>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com>
	 <1243527919.6645.75.camel@laptop>
Content-Type: text/plain
Date: Thu, 28 May 2009 18:47:36 +0200
Message-Id: <1243529256.6645.78.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 18:25 +0200, Peter Zijlstra wrote:
> >      - uint64_t exclude_*
> > 
> >        It seems those fields were added to support the generic HW events. But
> >        I think they are confusing and their semantic is not quite clear.
> > 
> >        Furthermore, aren't they irrelevant for the SW events?
> 
> They are.

It seems I can't read. They are _not_ irrelevant, sw events do honour
them. We can for instance distinguish between the kernel causing a
pagefualt and userspace doing so.

