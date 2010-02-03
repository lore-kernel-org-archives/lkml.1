Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab0BCXuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:50:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:33876 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab0BCXuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:50:21 -0500
Subject: Re: [RFC][PATCH] perf_events, x86: PEBS support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jamie Iles <jamie.iles@picochip.com>, Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, perfmon2-devel@lists.sf.net
In-Reply-To: <1265208012.24455.592.camel@laptop>
References: <1265129772.24455.329.camel@laptop>
	 <20100202182653.GB19320@elte.hu> <1265135588.24455.350.camel@laptop>
	 <bd4cb8901002030522s6306fdf4qbf4eb48c0674d980@mail.gmail.com>
	 <1265205361.24455.533.camel@laptop>
	 <bd4cb8901002030607y519c191av733231ba2aec2e9c@mail.gmail.com>
	 <1265206784.24455.568.camel@laptop>
	 <bd4cb8901002030630naaa83c1j397759750007ae4c@mail.gmail.com>
	 <1265208012.24455.592.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 00:50:10 +0100
Message-ID: <1265241010.24455.1627.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 15:40 +0100, Peter Zijlstra wrote:
> 
> If only they would reset the counter on overflow instead of on record,
> that would solve quite a few issues I imagine. 

So I tried enabling the regular PMC overflow interrupt and reprogramming
the counter from that, but touching the counter seems to destroy the
PEBS assist, so much for that idea.

