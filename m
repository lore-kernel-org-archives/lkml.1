Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbZKWIpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbZKWIpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 03:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZKWIpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 03:45:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZKWIpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 03:45:49 -0500
Date: Mon, 23 Nov 2009 09:45:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: support static build
Message-ID: <20091123084543.GC23635@elte.hu>
References: <20091029152002.GA5406@redhat.com>
 <20091104110604.GE13194@elte.hu>
 <20091117092331.GA23585@elte.hu>
 <20091122112726.GC13644@redhat.com>
 <20091122113942.GD13644@redhat.com>
 <19209.48577.356560.738625@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19209.48577.356560.738625@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Michael S. Tsirkin writes:
> 
> > Btw, why is it a good idea to force 64/32 bit mode?
> > Why not use the default gcc mode?
> 
> On powerpc the gcc default is often 32-bit even when running under a 
> 64-bit kernel, but we want to build perf 64-bit if possible.

This can then be forced by doing something like:

  make EXTRAFLAGS=-m64

... but i'd not mind a PowerPC default for EXTRAFLAGS either.

	Ingo
