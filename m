Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbXFDUqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbXFDUqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbXFDUqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:46:16 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:52895 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbXFDUqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:46:15 -0400
Subject: Re: [PATCH -mm 0/5] LZO and swap write failure patches for -mm
From: Richard Purdie <rpurdie@openedhand.com>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Woodhouse <dwmw2@infradead.org>,
       Nitin Gupta <nitingupta910@gmail.com>
In-Reply-To: <200706041337.51563.dhazelton@enter.net>
References: <1180971378.6313.72.camel@localhost.localdomain>
	 <200706041214.38017.dhazelton@enter.net>
	 <1180975976.6313.133.camel@localhost.localdomain>
	 <200706041337.51563.dhazelton@enter.net>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 21:45:55 +0100
Message-Id: <1180989955.6313.168.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 13:37 -0400, Daniel Hazelton wrote:
> Yes - most of that work, IIRC, is related to the alignment issues that Herr 
> Oberhumer noted. As it stands, the alternative does work well for a large 
> number of the platforms that the kernel supports. With a little Kconfig magic 
> it could be made available *only* for those platforms that it currently 
> supports. Then people can help work on the alignment issues - possibly by 
> providing platform conditional code.

My patch was actually written with ARM machines in mind and has been
extremely well tested on it. A version which doesn't run on ARM is not
acceptable. Its also ironic that "platform conditional code" is what a
lot of that bloat you're so keen to remove is about.

> I'm not familiar with the zlib code, but it was included a long time ago - 
> since zlib was included I'm pretty certain that if it had been proposed today 
> it would have been NACK'd for the style violations and bloat.

Adrian's covered this. I also know how hard updating something like zlib
is (I was the last person to do it).

> You can take the time to produce a patch and spread FUD about the speed of a 
> competing patches code but you don't have the time to work on fixing a 
> cleaner implementation? I'll admit that actually working on fixing problems 
> in code can take more time, but still - the time taken for those pursuits 
> *could* have been spent actually working on fixing the problems.

I *have* spent some time on it.

My speed comments were actually pretty positive. Yes, I screwed up one
of the benchmarks (as have others proving its easily done) but I did
admit to it. My others were fair comment and some issues were addressed
as a result (but not all).

I'm going to stop here. I don't agree with the rest of your email and
you've a distorted view of whats been said.

Regards,

Richard

