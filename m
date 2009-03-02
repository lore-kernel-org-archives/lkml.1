Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbZCBJYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbZCBJYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 04:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbZCBJX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 04:23:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53639 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbZCBJX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 04:23:56 -0500
Date: Mon, 2 Mar 2009 10:23:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Stuart Bennett <stuart@freedesktop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] mmiotrace: enhance01
Message-ID: <20090302092342.GA12924@elte.hu>
References: <20090301160643.05a2219b@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090301160643.05a2219b@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> Hi all,
> 
> the following patch set is mostly mmiotrace stability and bug fixes.
> It is meant for 2.6.30, has been developed on linus/master (post 2.6.29-rc6),
> and applies cleanly to tip/master.
> 
> It has been tested on Athlon64 3000+ (x86_64) by testmmiotrace.ko and
> tracing the Nouveau driver, and also on Core 2 Duo (Thinkpad T61, x86_64)
> by testmmiotrace.ko and tracing the Nvidia proprietary driver.
> 
> Special thanks to Stuart, who provided most of the fixes.
> 
>  arch/x86/mm/kmmio.c         |  149 +++++++++++++++++++++++++++---------------
>  arch/x86/mm/testmmiotrace.c |   70 ++++++++++++++++----
>  2 files changed, 153 insertions(+), 66 deletions(-)

Applied to tip:tracing/mmiotrace, thanks guys!

	Ingo
