Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbYKWOES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbYKWOES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 09:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758146AbYKWOEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 09:04:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42548 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758045AbYKWOED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 09:04:03 -0500
Date: Sun, 23 Nov 2008 15:03:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: Re: Mmiotrace regression in 2.6.28-rc6
Message-ID: <20081123140355.GA17396@elte.hu>
References: <20081123154148.04e0851a@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123154148.04e0851a@daedalus.pq.iki.fi>
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

> Hi Steve,
> 
> now that the NULL deref bug in ring buffer resize is gone, I found
> another regression.
> 
> It seems I am not getting any "buffer overflow" messages anymore.
> 
> Oh bummer, looks like I completely missed this one:
> (hope it's not in any .27 kernel)

yeah, the ring-buffer is new in .28.

	Ingo
