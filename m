Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZLKN07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZLKN07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbZLKN0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:26:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49315 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbZLKN0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:26:52 -0500
Date: Fri, 11 Dec 2009 14:26:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jamie Iles <jamie.iles@picochip.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, mikpe@it.uu.se, linux@arm.linux.org.uk,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf tools: Allow building for ARM
Message-ID: <20091211132640.GA12140@elte.hu>
References: <1260534009-5394-1-git-send-email-jamie.iles@picochip.com>
 <tip-58e9f94138c1d9c47f6a63632ca7a78fc6dcc15f@git.kernel.org>
 <20091211130408.GG4164@wear.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211130408.GG4164@wear.picochip.com>
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


* Jamie Iles <jamie.iles@picochip.com> wrote:

> On Fri, Dec 11, 2009 at 12:54:33PM +0000, tip-bot for Jamie Iles wrote:
> > Commit-ID:  58e9f94138c1d9c47f6a63632ca7a78fc6dcc15f
> > Gitweb:     http://git.kernel.org/tip/58e9f94138c1d9c47f6a63632ca7a78fc6dcc15f
> > Author:     Jamie Iles <jamie.iles@picochip.com>
> > AuthorDate: Fri, 11 Dec 2009 12:20:09 +0000
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 11 Dec 2009 13:50:21 +0100
> > 
> > perf tools: Allow building for ARM
> > 
> > Add definitions of rmb() and cpu_relax() and include the ARM
> > unistd.h header. The __kuser_memory_barrier helper in the helper
> > page is used to provide the correct memory barrier depending on
> > the CPU type.
> > 
> > [ The rmb() will work on v6 and v7, segfault on v5. Dynamic
> >   detection to add v5 support will be added later. ]
>
> Sorry Ingo, my comment probably wasn't clear enough. The helper that 
> Mikael suggested should work for _all_ ARM processors including v5 and 
> earlier. It will just be a branch to a nop.

oh - good! Too late to fix the comment, i already pushed it out - but as 
long as the _code_ is fine it's a good tradeoff ;-)

	Ingo
