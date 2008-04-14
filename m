Return-Path: <linux-kernel-owner+w=401wt.eu-S1762644AbYDNRdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644AbYDNRdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761534AbYDNRdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:33:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35340 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbYDNRdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:33:24 -0400
Subject: Re: API documentation (was [PATCH] Replace completions with
	semaphores)
From: Peter Zijlstra <peterz@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>, Roland Dreier <rdreier@cisco.com>,
       Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <16641.1208193124@vena.lwn.net>
References: <16641.1208193124@vena.lwn.net>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 19:33:15 +0200
Message-Id: <1208194395.7129.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 11:12 -0600, Jonathan Corbet wrote:
> Bart Van Assche <bart.vanassche@gmail.com> wrote:
> 
> > The LWN book is getting outdated after all the 2.6 kernel API changes,
> > and the page with 2.6 kernel API changes was last updated six months
> > ago. Where can a kernel developer find up to date information about
> > kernel programming ?
> 
> The failure to update the API changes page is just me not managing to
> get around to it.  I'll do my best to take care of that in the next few
> days.  Apologies for that.
> 
> Updating LDD (which isn't really "the LWN book" though it's hosted here)
> will take a little longer.  I'd like to find a way to produce an LDD4
> with quality at least as good as LDD3, but which doesn't fill the world
> with immediately-obsolete bricks of dead trees.  Still working on it...

Books should only be used to obtain the general picture, any details
will be instantly-obsolete, esp at the pace Linux changes.

Most of the concepts from LDD3 are still valid, many of the details are
dead wrong.

Can't we make LDD4 a high level book, explcitly mentioning how people
should go about obtaining details? Like go ask on #kernelnewbies and the
sorts.

The thing I always tell #kernelnewbies people is to look at a related
driver (of course that kite doesn't always fly). Another good way to
learn stuff is to just read the implementation.

A 'trick' that is often useful is to look in git to see how something
was changed, provided you knew how to do it some time in the past.



