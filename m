Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbZJ2IG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbZJ2IG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZJ2IGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:06:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56957 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbZJ2IGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:06:51 -0400
Date: Thu, 29 Oct 2009 09:06:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: support static build
Message-ID: <20091029080642.GB26970@elte.hu>
References: <20091028070459.GA22695@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028070459.GA22695@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@redhat.com> wrote:

> This makes it possible to build perf statically, by performing
> make LDFLAGS=-static
> Since static libraries are only searched in the order they are
> specified, move library list from LDFLAGS to EXTLIBS, so that
> they are put at the end of linker command line.

Nice!

>  tools/perf/Makefile |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)

Would you mind to send a patch against the latest perf events tree, 
which can be found at:

  http://people.redhat.com/mingo/tip.git/README

This patch does not apply anymore due to recent changes to the Makefile:

 patching file tools/perf/Makefile
 Hunk #2 FAILED at 204.
 Hunk #3 FAILED at 424.
 2 out of 3 hunks FAILED -- rejects in file tools/perf/Makefile

Thanks,

	Ingo
