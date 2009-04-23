Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbZDWVO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbZDWVO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbZDWVOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:14:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35261 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652AbZDWVOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:14:18 -0400
Date: Thu, 23 Apr 2009 23:02:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Peter Zijlstra <peterz@infradead.org>,
       Peter Lojkin <ia6432@inbox.ru>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 057/100] posix-timers: fix RLIMIT_CPU && fork()
Message-ID: <20090423210231.GA18661@redhat.com>
References: <20090423072020.428683652@sous-sol.org> <20090423072700.322939119@sous-sol.org> <20090423165940.622c8ad8@dhcp-100-2-144.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423165940.622c8ad8@dhcp-100-2-144.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Chuck Ebbert wrote:
>
> On Thu, 23 Apr 2009 00:21:17 -0700
> Chris Wright <chrisw@sous-sol.org> wrote:
>
> > -stable review patch.  If anyone has any objections, please let us know.
> > ---------------------
> >
> > From: Oleg Nesterov <oleg@redhat.com>
> >
> > upstream commit: 6279a751fe096a21dc7704e918d570d3ff06e769
> >
>
> The following commit was also submitted:
>
>    37bebc70d7ad4144c571d74500db3bb26ec0c0eb
>    posix timers: fix RLIMIT_CPU && fork()
>
> Did it get dropped because it has the exact same title?

The commit above should be dropped, I'll send the "please revert" patch.

It was supposed to be the most simple fix for soon-to-be-released 2.6.29

Oleg.

