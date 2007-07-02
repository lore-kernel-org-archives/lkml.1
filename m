Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbXGBO7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbXGBO7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbXGBO7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:59:46 -0400
Received: from vena.lwn.net ([206.168.112.25]:60843 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbXGBO7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:59:46 -0400
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net
Subject: Re: [PATCH] Documentation: improvement to volatile considered harmful (resubmit) 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Sun, 01 Jul 2007 15:26:22 +0300."
             <20070701122622.GC3400@zakalwe.fi> 
Date: Mon, 02 Jul 2007 08:59:45 -0600
Message-ID: <15122.1183388385@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heikki Orsila <shdl@zakalwe.fi> wrote:

> I'm resubmitting this as I didn't get any replies, this time CCeing 
> proper people, sorry..
> 
> Kernel locking/synchronization primitives are better than volatile types 
> from code readability point of view also.

I think that just dilutes the real point.  It's not a choice between
locking and volatile - the locking must be there regardless.  It's a
correctness issue; if the result happens to be more readable too that's
a bonus.

If somebody wants to put this sentence in I won't object, but I don't
think it really improves the document either.

Thanks,

jon
