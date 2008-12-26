Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbYLZI5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbYLZI5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 03:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYLZI5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 03:57:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41705 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbYLZI5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 03:57:15 -0500
Date: Fri, 26 Dec 2008 09:56:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] signal: let valid_signal() check more
Message-ID: <20081226085654.GE755@elte.hu>
References: <20081226012612.GI3130@hack.private> <20081225180054.GA24116@redhat.com> <20081226144928.GC3156@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081226144928.GC3156@hack.private>
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


* Américo Wang <xiyou.wangcong@gmail.com> wrote:

> >> @@ -727,7 +727,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
> >>  	{
> >>  		if (!perm || !capable(CAP_KILL))
> >>  			goto eperm;
> >> -		if (!valid_signal(arg) || arg < 1 || arg == SIGKILL)
> >> +		if (!valid_signal((int)arg) || arg == SIGKILL)
> >                                  ^^^^^
> >
> >The patch adds a lot of unnecessary typecasts like this.
> 
> because it's inline?

Why does your patch add a lot of seemingly unnecessary typecasts? [if your 
short reply was supposed to be an answer to that question then please 
explain it in more detail.]

	Ingo
