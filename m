Return-Path: <linux-kernel-owner+w=401wt.eu-S1761737AbYGOCqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761737AbYGOCqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYGOCp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:45:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34118
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbYGOCp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:45:57 -0400
Date: Mon, 14 Jul 2008 19:45:57 -0700 (PDT)
Message-Id: <20080714.194557.78177585.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: rene.herman@keyaccess.nl, david@lang.hm, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0807141934060.3017@woody.linux-foundation.org>
References: <487C0A12.9060906@keyaccess.nl>
	<20080714.192425.241878700.davem@davemloft.net>
	<alpine.LFD.1.10.0807141934060.3017@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Jul 2008 19:39:03 -0700 (PDT)

> Put this way: if you do a distro, you _need_ to support firmware loading 
> anyway. And once you do that, it's just annoying how some drivers then do 
> something odd and special for the same thing, for no real good reason.

In what way is it annoying?

Most distribution people aren't even aware that drivers like tg3 and
bnx2 even have firmware.  In fact it's self contained and less for
them to worry about.

The correct firmware is right there in the driver, it's what the
driver maintainer tested as a unit, and everything.

It neither gets in the distro guys way nor causes any functional
problems.

It may cause potential legal issues, but that is another matter.

> It's like having each wireless driver do their own 802.11 stack. It works, 
> and all those driver writers seem to be always convinced that it's the 
> right thing to do. But as a network maintainer, do you like it?
> 
> Now, replace "802.11 stack" with "firmware loader", and then replace 
> "network maintainer" with "kernel maintainer".

Distro folks do ship external drivers that have their own 802.11
stack, so this is a very good example in fact :-)

I think the modular vs. static kernel image is a better analogy.
At least with that I have a real choice, with this stuff I suddently
won't.

Regardless of what you or I think about these changes, the fact is
that there were definitely some areas of contention and even some
level of misrepresentation of these changes.  And given that, some
of us feel that merging this in right now was on the premature side.
