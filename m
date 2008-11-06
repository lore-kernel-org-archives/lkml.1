Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbYKFJ4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbYKFJ4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYKFJz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:55:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43780 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbYKFJz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:55:58 -0500
Date: Thu, 6 Nov 2008 10:55:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, T?r?k Edwin <edwintorok@gmail.com>,
       srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081106095547.GK4890@elte.hu>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081102212512.GF28946@ZenIV.linux.org.uk> <490E1B74.6010904@gmail.com> <20081102214042.GG28946@ZenIV.linux.org.uk> <20081103073257.GA13727@elte.hu> <20081104182628.GA6666@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104182628.GA6666@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Nov 03, 2008 at 08:32:57AM +0100, Ingo Molnar wrote:
> > could you please help out with such a helper? This is really about 
> > visualization, not to rely on it.
> 
> Is this kindergarten? [...]

No, this is lkml where, if you decide to stand in the way of a patch, 
you are supposed to back up your NAK's with a path out of that NAK. 
Instead of forcing people into multiple email ping-pongs trying to 
figure out what exactly the objections mean.

Look at the time flow of the mails:

 |  Nov  2   22:18:21 2008        # submission
 |  Nov  2   22:25:16 2008        # +7 minutes, NAK with no comment 
 |
 |  [ ~5 unnecessary mails ]
 |
 |  Nov  4   20:09:13 20008       # +2 days, ACK

What was done was inefficent and unnecessary, it caused a hickup and 
delay of 2 days in the workflow - at the point of the NAK it was 
already known what the right solution is, it just was obscured behind 
a moody reply. Such obstruction adds up and it simply does not scale 
as a form of communication.

Nobody learned anything new compared to the case had the +7 minutes 
reply included this information already.

	Ingo
