Return-Path: <linux-kernel-owner+w=401wt.eu-S1161359AbXDVQRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161359AbXDVQRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 12:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161362AbXDVQRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 12:17:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52962 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161359AbXDVQRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 12:17:37 -0400
Date: Sun, 22 Apr 2007 17:20:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Tilman Schmidt" <tilman@imap.cc>, "David Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de, akpm@linux-foundation.org
Subject: Re: [PATCH] Remove "obsolete" label from ISDN4Linux (v3)
Message-ID: <20070422172017.52f21a90@the-village.bc.nu>
In-Reply-To: <a781481a0704220848t16cc8ed2l3cb5ee52d9b405e1@mail.gmail.com>
References: <20070115172912.GA3323@pingi.kke.suse.de>
	<462A0CA7.2090908@imap.cc>
	<20070421215844.542d3aab@the-village.bc.nu>
	<20070421.151052.78709111.davem@davemloft.net>
	<462B54A0.9000203@imap.cc>
	<20070422135835.037e323c@the-village.bc.nu>
	<462B712D.7070504@imap.cc>
	<20070422161708.54253ab7@the-village.bc.nu>
	<a781481a0704220848t16cc8ed2l3cb5ee52d9b405e1@mail.gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> simple and fundamental (which you haven't answered as yet). Why, or
> rather how, were the writers of newer APIs _allowed_ to push *their*
> stuff into the kernel _without_ even bothering to convert the
> *existing* users of the older APIs in the kernel? This goes against

Because to convert the existing ISDN4Linux heap into the new APIs would
require someone with all the cards involved and a lot of time (as the
card drivers need a *lot* of work by now to bring them up to todays work)

> the spirit of pretty much how anything is done in here ... one can't
> really find fault with the original author of I4L for not using APIs
> that didn't even exist when he wrote I4L.

Of course not - and I4L as originally merged is very different to I4L as
it is now - both because it was maintained and because other people fixed
things when it was easy to do so (eg the tty layer changes).

> and working kernel subsystem to their newer APIs. If we allow
> something like this (or if this was allowed in the past), then we
> could be setting a very unfortunate precedent.

"Precedent", that implies it is a new behaviour - which it isn't. We
regularly break old driver code when it is neccessary in order to make
general progress. Grep for "BROKEN" in the kernel tree.

> I really don't have any specific knowledge of the I4L codebase, so
> perhaps you and Dave do have better reasons to keep it marked as
> obsolete (and *allow* it get broken by API changes in the future).

If the changes to make it use pci_get_ were trivial I'd simply have
pushed them, but they are not due to the rather bizarre structure of some
of the drivers - ditto some of the other changes.

You, and anyone else who wants to, are free to work on I4L and fix it,
improve it and make it better. 

Alan
