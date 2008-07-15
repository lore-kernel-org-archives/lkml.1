Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbYGOE5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbYGOE5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 00:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYGOE5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 00:57:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:47874 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYGOE5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 00:57:01 -0400
Date: Mon, 14 Jul 2008 21:56:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, rene.herman@keyaccess.nl, david@lang.hm,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
Message-ID: <20080714215648.1ed29448@infradead.org>
In-Reply-To: <20080714.194557.78177585.davem@davemloft.net>
References: <487C0A12.9060906@keyaccess.nl>
	<20080714.192425.241878700.davem@davemloft.net>
	<alpine.LFD.1.10.0807141934060.3017@woody.linux-foundation.org>
	<20080714.194557.78177585.davem@davemloft.net>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 19:45:57 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 14 Jul 2008 19:39:03 -0700 (PDT)
> 
> > Put this way: if you do a distro, you _need_ to support firmware
> > loading anyway. And once you do that, it's just annoying how some
> > drivers then do something odd and special for the same thing, for
> > no real good reason.
> 
> In what way is it annoying?
> 
> Most distribution people aren't even aware that drivers like tg3 and
> bnx2 even have firmware.  In fact it's self contained and less for
> them to worry about.

and.. after this patch that still seems to be the case, unless I'm
looking at it really cross eyed.
Nothing in this patch makes it impossible to do so.. or changes the
drivers you mention. in fact it's the opposite almost: it improves
request_firmware() usability significantly. (by allowing vmlinux build
in etc).



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
