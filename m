Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZDLNhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZDLNhp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 09:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZDLNhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 09:37:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41314 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbZDLNhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 09:37:35 -0400
Date: Sun, 12 Apr 2009 15:37:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] blktrace: fix output of BLK_TC_PC events
Message-ID: <20090412133714.GB384@elte.hu>
References: <49D3236D.3090705@cn.fujitsu.com> <49D32387.9040106@cn.fujitsu.com> <49E051B9.8060805@cn.fujitsu.com> <20090412130727.GC20281@elte.hu> <20090412131028.GT5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412131028.GT5178@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Sun, Apr 12 2009, Ingo Molnar wrote:
> > 
> > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> > > Hi Ingo,
> > > 
> > > I would like to ask what's the status of these 2 patches.
> > > 
> > > Arnaldo acked on them.
> > 
> > They looked good to me - but i'm waiting for an Ack from Jens. Jens 
> > has complained about seeing un-ack-ed patches in the blktrace code, 
> > so i've started serializing any new patches on acks from Jens. The 
> > workflow would be more efficient i suspect if Jens 
> > nominated/declared you and Arnaldo as blktrace co-maintainers too - 
> > most of the patches come from you two.
> 
> I'd be fine with listing Li Zefan as co-maintainer of the blktrace 
> bits. He knows what he is doing and is also a user of blktrace, so 
> I think he would be fine. Li, what do you think?

Cool ... i've also taken this as an implicit approval from you of Li 
sending blktrace patches so i have queued the two up.

The next big (and nice!) step would be the blktrace events in 
TRACE_EVENT() style. That would integrate the blktrace tracepoints 
with all the others, in one coherent framework.

Thanks,

	Ingo
