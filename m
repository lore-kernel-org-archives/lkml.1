Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbYG2Qnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbYG2Qnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYG2QnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:43:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56266 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbYG2QnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:43:23 -0400
Date: Tue, 29 Jul 2008 18:42:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>
Subject: Re: linux-next: build failure
Message-ID: <20080729164256.GA540@elte.hu>
References: <20080729180317.94c64634.sfr@canb.auug.org.au> <20080729085815.GA1301@elte.hu> <20080729202731.F18F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080729114029.GA3836@elte.hu> <alpine.LFD.1.10.0807290927240.3334@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807290927240.3334@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> In contrast, "address-of lvalue" is _guaranteed_ to not do anything 
> stupid like that, and gives just the address-of.
> 
> Oh, and I was wrong about the &*x losing the 'const'. It doesn't. So I 
> think Stephen's patch is fine after all - if somebody tries to modify 
> the end result through the pointer, it will give a big compiler 
> warning.

yeah, both variants do that, i've checked it earlier today - i tried to 
find a way to get something more drastic than a compiler warning. (but 
failed)

	Ingo
