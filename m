Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZJAIV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZJAIV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbZJAIVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:21:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36881 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867AbZJAIVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:21:22 -0400
Date: Thu, 1 Oct 2009 10:21:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [origin tree boot crash] Re: [GIT PATCH] TTY patches for
	2.6.31-git
Message-ID: <20091001082115.GA12200@elte.hu>
References: <20090919213345.GB7668@kroah.com> <20090930100902.GA29872@elte.hu> <20090930111726.618af641@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930111726.618af641@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Wed, 30 Sep 2009 12:09:02 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > >       serial: use tty_port pointers in the core code
> > 
> > -tip testing found a weird serial code related crash on a testbox: the 
> > box does spontaneous reboot during the user-space portions of bootup. 
> 
> Does this only occur if running with serial console ?

Hm, removing the serial console boot line portion still causes a 
spontaneous reboot. Same for removing /bin/setserial and removing 
/dev/ttyS0 and /dev/ttyS1.

That would exclude all possible uses of the codepath affected by that 
commit, right?

If yes i'd shuffle this into the 'weird things' bucket, waiting for a 
more debuggable scenario to pop up.

	Ingo
