Return-Path: <linux-kernel-owner+w=401wt.eu-S933768AbZLFLzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768AbZLFLzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 06:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933724AbZLFLzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 06:55:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54047 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933723AbZLFLzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 06:55:02 -0500
Date: Sun, 6 Dec 2009 12:54:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf: Fix timechart header handling
Message-ID: <20091206115458.GA21964@elte.hu>
References: <87ljhg8ioe.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljhg8ioe.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Hi,
> 
> Update "struct trace_entry" to match with current one. And remove
> "size" field from it.
> 
> If it has "size", it become cause of alignment mismatch of structure
> with kernel.
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  tools/perf/builtin-timechart.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Just curious, have you tested timechart functionality after having done 
this change - does it still work fine for you?

Thanks,

	Ingo
