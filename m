Return-Path: <linux-kernel-owner+w=401wt.eu-S1759202AbZEFLEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbZEFLEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbZEFLEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:04:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48729 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758971AbZEFLEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:04:04 -0400
Date: Wed, 6 May 2009 13:03:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4/jbd2: remove stray markers
Message-ID: <20090506110354.GG25203@elte.hu>
References: <20090506104436.GA24047@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506104436.GA24047@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@lst.de> wrote:

> ext4/jbd2 has a couple of stray markers without any users 
> introduced in commit ba80b1019aa722b24506db1ee755e0bb2f513022 
> (which has a very useless changelog, btw).  Remove them in 
> preparation of removing the markers in favour of the TRACE_EVENT 
> macro (and also because we don't keep dead code around).
> 
> Ted, I think you have some TRAVE_EVENT patches for ext4 pending, 
> but is it okay to queue up this removal in the tracing tree?  That 
> way we can remove the markers leftovers there completely as soon 
> as the 2.6.31 merge window opens.

i think these markers are still in active use, so i'd not remove 
them before Ted's TRACE_EVENT() changes are included. We can/should 
do that in a single topic - in a work flow that suits Ted best.

We can do a -git based special-purpose topic branch in -tip, or we 
can do it in tip/tracing, or we can pull a (-git based) branch from 
Ted. Or we can delay it all to the v2.6.31 merge window. Ted's 
choice.

	Ingo
