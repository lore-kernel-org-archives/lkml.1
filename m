Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbZJVTUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbZJVTUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 15:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbZJVTUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 15:20:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50556 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352AbZJVTUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 15:20:00 -0400
Date: Thu, 22 Oct 2009 21:19:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
Subject: Re: zaurus: cleanup sharpsl_pm.c
Message-ID: <20091022191954.GB6611@elf.ucw.cz>
References: <20091006200339.GA1538@ucw.cz>
 <20091017163627.GB1423@ucw.cz>
 <f17812d70910200859v6d18e81bs2760d8af1d8da5bf@mail.gmail.com>
 <f17812d70910220705o9f4a0ddwa22157b59a519350@mail.gmail.com>
 <20091022174816.GC5325@elf.ucw.cz>
 <f17812d70910221126k50c4ea7em9d58f6e85db884ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70910221126k50c4ea7em9d58f6e85db884ae@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-10-23 02:26:55, Eric Miao wrote:
> > Introduce separate set of battery limits for corgi. This fixes
> > compilation, and the values probably should be subtly different, too.
> 
> [Why I'm receiving this for twice ....?]

No idea. Perhaps once from maillist?

> Pavel,
> 
> Anyway, I was thinkin maybe we need a shared table before there
> are real requirements for different machines to have their own?

Well, I'd say that the sharing leads to some very ugly code. ... so
I'd preer it unshared.

But if you would prefer, I can prepare patch without the table
moving...?

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
