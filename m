Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbZKQGBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbZKQGBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZKQGBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:01:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33239 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbZKQGBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:01:50 -0500
Date: Tue, 17 Nov 2009 07:01:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 3/3] Add get_signal tracepoint
Message-ID: <20091117060130.GB30852@elte.hu>
References: <20091113225226.15079.90813.stgit@harusame>
 <20091113225240.15079.4863.stgit@harusame>
 <20091113235333.0E3CC15E8@magilla.sf.frob.com>
 <20091114001020.GB24738@elte.hu>
 <4B01C95B.1070302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B01C95B.1070302@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> >  - signal IPI/wakeup events
> 
> All signals might be used for IPI, isn't it? :-)

I mean, to analyze the various dynamic delivery details of how a signal 
send affects a target task:

 1) which task/PID was selected to be woken

 2) if the task got woken (from sleep) due to the signal sending

 3) if it was already woken, whether it needed an IPI via kick_process()

What proportion of signals were wakeups and what proportion hit an 
already running task is a relevant question to ask when analyzing the 
performance characteristics of signals.

	Ingo
