Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbXKLKVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbXKLKVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 05:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbXKLKVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 05:21:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49699 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbXKLKVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 05:21:13 -0500
Subject: Re: [PATCH] Include header required for INT_MAX
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: axboe@kernel.dk, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0711112349580.15517@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711112349580.15517@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Mon, 12 Nov 2007 11:21:10 +0100
Message-Id: <1194862870.7179.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-11-11 at 23:52 +0100, Jan Engelhardt wrote:
> >> Nack, we shoiuld never include userspace headers in kernel headers,
> >> an even more never add !__KERNEL__ ifdefs.  Just make sure your
> >> programs include limit.h before including linux/cdrom.h.
> >
> >I think header files should be complete, and should not use undefined
> >macros, picking up every random definition that may be in effect when
> >the header is included, don't you agree? 
> 
> No, because I be damn sure that some developers try compiling programs 
> in non-linux environments (cygwin, solaris, andyourpersonaldistro, you 
> name it) which do not have to adhere to <limits.h>. It might use 
> <cosmiclimits.h> instead, or whatever.
> Hence, such extra includes are a nogo.

Surely ISO-C99 has something to say on this subject?

