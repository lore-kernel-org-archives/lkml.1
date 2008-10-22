Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbYJVPCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbYJVPCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYJVPCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:02:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39476 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbYJVPCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:02:20 -0400
Date: Wed, 22 Oct 2008 17:02:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ring-buffer: fix free page
Message-ID: <20081022150203.GD23060@elte.hu>
References: <alpine.DEB.1.10.0810131021190.4157@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810131021190.4157@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> The pages of a buffer was originally pointing to the page struct, it
> now points to the page address. The freeing of the page still uses
> the page frame free "__free_page" instead of the correct free_page to
> the address.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/ring_buffer.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to tip/tracing/urgent, thanks Steve!

	Ingo
