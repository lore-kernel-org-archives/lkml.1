Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbZKNACs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbZKNACs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932521AbZKNACr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:02:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39513 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514AbZKNACr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:02:47 -0500
Date: Sat, 14 Nov 2009 01:02:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 2/3] Add coredump tracepoint
Message-ID: <20091114000234.GA24738@elte.hu>
References: <20091113225226.15079.90813.stgit@harusame>
 <20091113225233.15079.41600.stgit@harusame>
 <20091113233912.192A3100E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113233912.192A3100E@magilla.sf.frob.com>
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


* Roland McGrath <roland@redhat.com> wrote:

> I can't really see what this has to do with "sched" to warrant that 
> name. But, whatever.

That's a misnomer indeed. I'd suggest to introduce a separate 'signal' 
subsystem category.

> Note that you put the tracepoint where it won't get called in the 
> various cases where no dump is really being made because of 
> RLIMIT_CORE or file failures.  I suspect you would like to get those 
> reported.  (Perhaps especially so, since there won't be any file 
> around to notice later.)

Yeah, good point.

> Also, it seems nice to give the tracepoint the chance to look at the 
> actual open file in case a fancy one wants to do that.

Oh, so SystemTap is the motivator of these tracepoints? Do you know 
about exact usecases where these tracepoints would be utilized? Would be 
interesting (and relevant) to list them.

	Ingo
