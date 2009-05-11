Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZEKQmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZEKQmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZEKQmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:42:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:34848 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbZEKQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:42:09 -0400
Date: Mon, 11 May 2009 09:41:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090511094151.6014cafb@infradead.org>
In-Reply-To: <ac3eb2510905110928g12545518y143f7f73b3ae494a@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	<20090510170016.1e3a4d97@infradead.org>
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
	<m1pregmkld.fsf@fess.ebiederm.org>
	<ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com>
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk>
	<ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com>
	<20090511141057.24a5f8ed@lxorguk.ukuu.org.uk>
	<ac3eb2510905110714m5877da13q19b42d1c8565777c@mail.gmail.com>
	<20090511165317.3da5326f@lxorguk.ukuu.org.uk>
	<ac3eb2510905110928g12545518y143f7f73b3ae494a@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 18:28:20 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> It isn't slow. It's just that bootstrapping/re-constructing something
> later can obviously never be faster than doing it when the device is
> created.

the performance gains from doing stuff in batches is obviously well
established; CPU caches cause that. Not saying that's a hot factor
here, the total only takes 0.01 second after all, but "obviously" isn't
true here.


> I don't know of any obvious fixes to udev, otherwise I would have
> implemented them.

there's not much to fix afaics. It'd be nice if it was the 0.06 seconds
that Eric gets, but 0.20 isn't all that bad either.

> > sh < /sys/initial-device-list
> 
> And you still need to cope with the races, and bring up the event
> listener before that. 

so ?

> This is less reliable and always slower than the
> kernel provided nodes, besides that your /sys/initial-device-list will
> be the same amount of code we need for the node creation right away,
> without any of the other benefits, and will require another
> special-case tool we don't use today.

it's not about the amount of code. It's about in how many useful ways
the code can be used!

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
