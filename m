Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXLDRyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXLDRyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbXLDRyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:54:15 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58356 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbXLDRyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:54:14 -0500
Date: Tue, 4 Dec 2007 12:54:13 -0500
To: "J.A. Magall??n" <jamagallon@ono.com>
Cc: Lo??c Greni?? <loic.grenie@gmail.com>, Ben.Crowhurst@stellatravel.co.uk,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071204175413.GD2310@csclub.uwaterloo.ca>
References: <474EAD18.6040408@stellatravel.co.uk> <9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com> <20071201001950.11100a32@werewolf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071201001950.11100a32@werewolf>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2007 at 12:19:50AM +0100, J.A. Magall??n wrote:
> I think BeOS was C++ and OSX is C+ObjectiveC (and runs on an iPhone).
> Original MacOS (fron 6 to 9) was Pascal (and a mac SE was very near
> to embedded hardware :) ).
> 
> I do not advocate to rewrite Linux in C++, but don't say a kernel written
> in C++ can not be efficient.

Well I am pretty sure the micro kernel of OS X is in C, and certainly
the BSD layer is as well.  So the only ObjC part would be the nextstep
framework and other parts of the Mac GUI and other Mac APIs they
provide, which all at some point probably end up calling down into the C
stuff below.

> C++ (and for what I read on other answer, nor ObjectiveC) has no garbage
> collection. It does not anything you did not it to do. It just allows
> you to change this
> 
> 	struct buffer *x;
> 	x = kmalloc(...)
> 	x->sz = 128
> 	x->buff = kmalloc(...)
> 	...
> 	kfree(x->buff)
> 	kfree(x)
> 	
> to
> 	struct buffer *x;
> 	x = new buffer(128); (that does itself allocates x->buff,
>                               because _you_ programmed it,
>                               so you poor programmer don't forget)
>         ...
> 	delete x;            (that also was programmed to deallocate
>                               x->buff itself, sou you have one less
>                               memory leak to worry about)

But kmalloc is implemented by the kernel.  Who implements 'new'?

--
Len Sorensen
