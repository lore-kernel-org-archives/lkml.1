Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbZDKT5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbZDKT5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZDKT5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:57:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757834AbZDKT5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:57:41 -0400
Date: Sat, 11 Apr 2009 12:52:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jeff Garzik <jeff@garzik.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
In-Reply-To: <20090411203246.513a0892@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0904111250370.4583@localhost.localdomain>
References: <49E0D47B.9070205@garzik.org> <20090411203246.513a0892@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 11 Apr 2009, Alan Cox wrote:
>
> > 	  The spec describes the sector size as
> > 	  "512, 1k, 2k, 4k, 8k, etc."   It will be interesting to reach
> > 	  "etc" territory.
> 
> Over 4K will be fun.

And by "fun", you mean "irrelevant".

If anybody does that, they'll simply not work. And it's not worth it even 
trying to handle it.

That said, I'm pretty certain Windows has the same 4k issue, so we can 
hope nobody will ever do that kind of idiotically broken hardware. Of 
course, hardware people often do incredibly stupid things, so no 
guarantees.

		Linus
