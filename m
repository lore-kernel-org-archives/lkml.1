Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbYDKN4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbYDKN4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 09:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760069AbYDKN4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 09:56:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41579 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758765AbYDKN4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:56:10 -0400
Date: Fri, 11 Apr 2008 15:55:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc8-mm2 -- =?utf-8?Q?kernel=2Fs?=
	=?utf-8?Q?ched=2Ec=3A8294=3A_error=3A_unknown_field_=E2=80=98read=5Fuint?=
	=?utf-8?B?4oCZ?= specified in initializer
Message-ID: <20080411135555.GA14342@elte.hu>
References: <a44ae5cd0804110648g3256805fob917f31eeff4f6db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0804110648g3256805fob917f31eeff4f6db@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Miles Lane <miles.lane@gmail.com> wrote:

>   CC      kernel/sched.o
> kernel/sched.c:8294: error: unknown field 'read_uint' specified in initializer
> kernel/sched.c:8294: warning: initialization makes integer from
> pointer without a cast
> kernel/sched.c:8295: error: unknown field 'write_uint' specified in initializer
> kernel/sched.c:8295: warning: initialization from incompatible pointer type

cannot reproduce it in sched-devel/for-akpm (which -mm is based off) nor 
in sched-devel/latest, using your config. Could you check sched-devel 
via:

  http://people.redhat.com/mingo/sched-devel.git/README

or maybe it's some other sched.c change in -mm? That line is around the 
control groups code and maybe that got changed in -mm?

meanwhile i built and successfully booted your config on a testsystem on 
sched-devel/latest. So if sched-devel/latest still fails for you then 
it's some build environment related detail that triggers the bug. If not 
then it's other changes in -mm.

	Ingo
