Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959Ab0AROVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab0AROVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761Ab0AROVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:21:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45836 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab0AROVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:21:13 -0500
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <bd4cb8901001180612g29369150h9db09470fa6000af@mail.gmail.com>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop>
	 <bd4cb8901001180612g29369150h9db09470fa6000af@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 15:20:52 +0100
Message-ID: <1263824452.4283.566.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 15:12 +0100, Stephane Eranian wrote:
> 
> > Then there's still the question of having events of multiple hw pmus in
> > a single group, I'd be perfectly fine with saying that's not allowed,
> > what to others think?
> >
> I have seen requests for measuring both core and uncore PMU events
> together for instance. It all depends on how uncore PMU will be managed.

OK, hard to correlate those two though, it would basically mean only
running that one task on the socket.

