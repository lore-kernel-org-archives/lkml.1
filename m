Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbZEQGf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbZEQGf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 02:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZEQGft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 02:35:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50958 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbZEQGfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 02:35:48 -0400
Date: Sun, 17 May 2009 08:35:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Sachin Sant <sachinp@in.ibm.com>
Subject: Re: [Bug #13068] Lockdep warining in inotify_dev_queue_event
Message-ID: <20090517063530.GB1583@elte.hu>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.UHD.QazDKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <385Pu-agh7M.A.UHD.QazDKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13068
> Subject		: Lockdep warining in inotify_dev_queue_event

s/warining/warning

> Submitter	: Sachin Sant <sachinp@in.ibm.com>
> Date		: 2009-04-05 12:37 (42 days old)
> References	: http://marc.info/?l=linux-kernel&m=123893439229272&w=4

i think this might be fixed by:

381a80e: inotify: use GFP_NOFS in kernel_event() to work around a lockdep false-positive

already in -rc6.

	Ingo
