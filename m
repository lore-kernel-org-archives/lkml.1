Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbYGKN77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbYGKN77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbYGKN7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:59:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39341 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759675AbYGKN7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:59:48 -0400
Date: Fri, 11 Jul 2008 15:59:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: today's linux-next fails to boot
Message-ID: <20080711135937.GA25004@elte.hu>
References: <4877400B.1000400@gmail.com> <s5hy747rvpr.wl%tiwai@suse.de> <48775C69.6050107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48775C69.6050107@gmail.com>
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


* Török Edwin <edwintorok@gmail.com> wrote:

> > [Added Ingo to Cc]
> >
> > I get the boot problem on i386 with 2008-07-11 linux-next tree, too.
> > In my case, no error appears on the screen, just staying blank and
> > dead.  It seems stopping at the very beginning, soon after GRUB, so
> > could be the same reason.
> >   
> 
> I don't see any boot messages on the screen, I get that BUG message as
> soon as grub's menu dissapears.
> I have bisected it to this range so far:
> git-bisect good aa03060a78c1aec53075a0c8ca7be19cedfbea8f
> git-bisect bad b1611c0058bc6635e7257e755c3f194933a7a6df
> 
> Should I continue to bisect?

could you check latest tip/master, does it boot fine with the same 
config?

	Ingo
