Return-Path: <linux-kernel-owner+w=401wt.eu-S1422642AbXDRJBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422642AbXDRJBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422653AbXDRJBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:01:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32798 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422642AbXDRJBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:01:42 -0400
Date: Wed, 18 Apr 2007 11:01:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Pfister <christophpfister@gmail.com>
Cc: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070418090117.GA20764@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704141809.58737.caglar@pardus.org.tr> <20070414160939.GB3099@elte.hu> <200704141959.50076.caglar@pardus.org.tr> <20070415161348.GA30625@elte.hu> <20070415162508.GA4526@elte.hu> <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <20070418082744.GA14009@elte.hu> <19a3b7a80704180157g604f4cecna51a49bd1f4c7d38@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19a3b7a80704180157g604f4cecna51a49bd1f4c7d38@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Pfister <christophpfister@gmail.com> wrote:

> >backtrace:
> >
> > #0  0xffffe410 in __kernel_vsyscall ()
> > #1  0x4a2510c6 in pthread_cond_wait@@GLIBC_2.3.2 () from 
> > /lib/libpthread.so.0
> > #2  0xb79fd1a8 in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
> > #3  0xb7a030ab in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
> > #4  0x4a24d2db in start_thread () from /lib/libpthread.so.0
> > #5  0x4a05820e in clone () from /lib/libc.so.6
> 
> This backtrace is useless - QWidget::setUpdatesEnabled() is certainly 
> _not_ defined in libxine. So the function names in #2 and #3 are wrong 
> because the addresses seem to belong to libxine.

are the updated backtraces in the followup mail i just sent more useful? 
(I still have that stuck session running so i can whatever debugging 
you'd like to see done.)

	Ingo
