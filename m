Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbZCWO4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbZCWO4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZCWO4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:56:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50714 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZCWO4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:56:15 -0400
Date: Mon, 23 Mar 2009 15:55:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: rostedt@goodmis.org, compudj@krystal.dyndns.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] kmemtrace: update usage of
	ring_buffer_lock_reserve()
Message-ID: <20090323145556.GA21267@elte.hu>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro> <c56426665804da261115c2883818c5fea6b217b6.1237813499.git.eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c56426665804da261115c2883818c5fea6b217b6.1237813499.git.eduard.munteanu@linux360.ro>
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


* Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> The ring buffer API has changed a bit and kmemtrace wasn't 
> compiling anymore. This fixes the issue and allows kmemtrace to 
> build.
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

hm, kmemtrace was building and working fine in -tip:

 [root@aldebaran tracing]# head trace
 # tracer: kmemtrace
 #
 type_id 0 call_site 18446744071565600429 ptr 18446612139794190624
 type_id 0 call_site 18446744071565600392 ptr 18446612146227278976
 type_id 1 call_site 18446744071564535786 ptr 18446612146228083456
 type_id 0 call_site 18446744071565600392 ptr 18446612146240588256
 type_id 1 call_site 18446744071564535786 ptr 18446612146240893824

the build error that is fixed by you here was introduced by your 
earlier 4/7 patch in this series:

   kmemtrace: use tracepoints

So i've backmerged patch 7/7 into patch 4/7. Agreed?

	Ingo
