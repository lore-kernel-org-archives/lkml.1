Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbZHNULE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbZHNULE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbZHNULD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:11:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34005 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbZHNULC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:11:02 -0400
Date: Fri, 14 Aug 2009 17:10:48 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] perf record: Fix typo in
	pid_synthesize_comm_event
Message-ID: <20090814201048.GG3490@ghostprotocols.net>
References: <20090814182632.GF3490@ghostprotocols.net> <28379.1250276831@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28379.1250276831@turing-police.cc.vt.edu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 14, 2009 at 03:07:11PM -0400, Valdis.Kletnieks@vt.edu escreveu:
> On Fri, 14 Aug 2009 15:26:32 -0300, Arnaldo Carvalho de Melo said:
> > We were using 'fd' locally, but there was a global 'fd' too, so when
> > converting from open to fopen the test made against fd should be made
> > against 'fp', but since we have that global...
> 
> If the kernel was -Wshadow safe by default, this sort of thing would happen
> less often... :)

I would love to have that kind of problem spotted by the compiler, but
this is no kernel code, the CFLAGS we use is different than the kernel
ones, I guess a patch for tools/perf/ would be gladly accepted by Ingo,
but let him say so :-)

- Arnaldo
