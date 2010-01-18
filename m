Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073Ab0ARLNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0ARLNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029Ab0ARLNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:13:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44006 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab0ARLNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:13:39 -0500
Subject: Re: [PATCH] perf_events: improve x86 event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net
In-Reply-To: <20100117141233.GF5035@nowhere>
References: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com>
	 <1263312616.4244.153.camel@laptop>
	 <bd4cb8901001130154p732672b6x56e758c1ab33a8e8@mail.gmail.com>
	 <1263400193.4244.238.camel@laptop>
	 <bd4cb8901001130852y1de007cbqe66d77605c1ec372@mail.gmail.com>
	 <bd4cb8901001130922s7ad85af6w6c631d90de177ef9@mail.gmail.com>
	 <20100117141233.GF5035@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 12:13:09 +0100
Message-ID: <1263813189.4283.245.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-17 at 15:12 +0100, Frederic Weisbecker wrote:

> You need to also call pmu->disable() if it is a software event,
> because a breakpoint needs to be unregistered in hardware level
> too.

breakpoint isn't a software pmu. But yeah, enable and disable need to
match.


