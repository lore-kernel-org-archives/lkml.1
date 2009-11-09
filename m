Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbZKIHQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbZKIHQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZKIHQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:16:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40188 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbZKIHQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:16:36 -0500
Date: Mon, 9 Nov 2009 08:15:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Yannick Roehlly <yannick.roehlly@free.fr>,
       Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jesse.barnes@intel.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>, berndl81@gmx.at,
       Greg KH <greg@kroah.com>
Subject: Re: Reverting 5d423 fixes loading of ath9k on Acer Extensa 7630EZ
Message-ID: <20091109071558.GC453@elte.hu>
References: <43e72e890911041540hd1e5f87u8d282d9c95857504@mail.gmail.com>
 <alpine.LFD.2.01.0911041551220.31845@localhost.localdomain>
 <20091105071431.GA14055@elte.hu>
 <43e72e890911081135q78416ef7ua6c5991b15fb2659@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890911081135q78416ef7ua6c5991b15fb2659@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Luis R. Rodriguez <mcgrof@gmail.com> wrote:

> On Wed, Nov 4, 2009 at 11:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> >> On Wed, 4 Nov 2009, Luis R. Rodriguez wrote:
> >> >
> >> > Can you please consider reviewing this issue and help determine if
> >> > this indeed needs to be reverted for 2.6.32 and the next 2.6.31.y.
> >> >
> >> > I am curious if other devices would work by reverting this as well.
> >> > [ ... ] For details please feel free to check:
> >> >
> >> > http://bugzilla.kernel.org/show_bug.cgi?id=14402
> >>
> >> That same commit was the cause for
> >>
> >> ?? ?? ?? http://bugzilla.kernel.org/show_bug.cgi?id=13940
> >>
> >> and we just increased the rounding to make it go away (see commit
> >> 15b812f1). But that was a hack.
> >>
> >> And if that didn't help the ath9k case, then we should just revert
> >> entirely.
> >
> > Agreed - below is the combo 15b812f1 + 5d423ccd revert. (Would be nice
> > to get the boot log of the latest post-15b812f1 kernel that Yinghai
> > asked for before we revert, in the hope of better understanding the
> > problem.)
> 
> Bernhard has confirmed the new patch fixes this issue.

Good - so latest kernels should be fine (on Bernhard's box) and no 
change is needed, right?

	Ingo
