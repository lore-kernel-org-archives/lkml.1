Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbYAVKh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbYAVKh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 05:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbYAVKhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 05:37:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43711 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052AbYAVKhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 05:37:20 -0500
Date: Tue, 22 Jan 2008 11:37:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Frederik Himpe <fhimpe@telenet.be>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
Message-ID: <20080122103708.GA21149@elte.hu>
References: <1200949086.6648.19.camel@Anastacia> <200801221105.11413.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801221105.11413.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 22 January 2008 07:58, Frederik Himpe wrote:
> > With Linux 2.6.24-rc8 I often have the problem that the pan usenet
> > reader starts using 100% of CPU time after some time. When this happens,
> > kill -9 does not work, and strace just hangs when trying to attach to
> > the process. The same with gdb. ﻿ps shows the process as being in the R
> > state.
> >
> > I pressed Ctrl-Alt-SysRq-T, and this was shown for pan:
> > Jan 21 21:45:01 Anastacia kernel: pan           R  running task        0 
> 
> Well I've twice tried to submit a patch to print stacks for running 
> tasks as well, but nobody seems interested. It would at least give a 
> chance to see something.

i definitely remembering having done this myself a couple of times (it 
makes tons of sense to get _some_ info out of the system) but some 
problem in -mm kept reverting it. I dont remember the specifics ... it 
was some race.

	Ingo
