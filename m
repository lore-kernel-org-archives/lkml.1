Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYAIUIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYAIUIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYAIUIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:08:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbYAIUIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:08:35 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other achitectures and kill notifier cruft"
Date: Wed, 9 Jan 2008 21:08:26 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       hch@lst.de, airlied@linux.ie, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, jbeulich@novell.com,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
References: <20080108192951.a4dc394f.akpm@linux-foundation.org> <20080109104149.GB8041@elte.hu> <20080109220148.5caebaf1@daedalus.pq.iki.fi>
In-Reply-To: <20080109220148.5caebaf1@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801092108.26550.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I have been reading about kprobes and one thing particularly bothers me
> in the case of mmio-trace. The probe will actually service the page
> fault, therefore it should be able force do_page_fault() to return at
> the probe point. I could not figure out a way to do that.
> 
> Is it possible to do reliably with kprobes or markers?

Probes are generally not designed to change the flow of the 
underlying code.

While it's in theory possible it will be always unreliable.

For checks that result in logic changes you'll always need
some kind of explicit hook.

-Andi



