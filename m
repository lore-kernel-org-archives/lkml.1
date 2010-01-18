Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980Ab0ARMTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0ARMTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667Ab0ARMTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:19:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab0ARMTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:19:39 -0500
Subject: Re: [PATCH] perf: fix the is_software_event() definition
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net
In-Reply-To: <20100118120747.GG5256@nowhere>
References: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com>
	 <1263312616.4244.153.camel@laptop>
	 <bd4cb8901001130154p732672b6x56e758c1ab33a8e8@mail.gmail.com>
	 <1263400193.4244.238.camel@laptop>
	 <bd4cb8901001130852y1de007cbqe66d77605c1ec372@mail.gmail.com>
	 <bd4cb8901001130922s7ad85af6w6c631d90de177ef9@mail.gmail.com>
	 <20100117141233.GF5035@nowhere> <1263813189.4283.245.camel@laptop>
	 <1263815616.4283.332.camel@laptop>  <20100118120747.GG5256@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 13:19:24 +0100
Message-ID: <1263817164.4283.394.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 13:07 +0100, Frederic Weisbecker wrote:

> Agreed.
> 
> But then Stephane will need to update his patch and use
> something else than is_software_event() to guess if an event
> needs its pmu->enable/disable to be called.

Yes, that's what I told him before and even send a patch for, the name I
chose was is_x86_event().

  http://lkml.org/lkml/2010/1/12/154



