Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZDLRbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZDLRbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbZDLRap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:30:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48049 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbZDLRan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:30:43 -0400
Message-ID: <49E22510.90608@garzik.org>
Date: Sun, 12 Apr 2009 13:29:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Grant Grundler <grundler@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <49E0D47B.9070205@garzik.org>	<20090411203246.513a0892@lxorguk.ukuu.org.uk>	<alpine.LFD.2.00.0904111250370.4583@localhost.localdomain>	<da824cf30904111449y5cb7c178ldf5291506ad6b393@mail.gmail.com> <20090412002527.631a5a89@lxorguk.ukuu.org.uk> <49E1F967.9090106@rtr.ca>
In-Reply-To: <49E1F967.9090106@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Alan Cox wrote:
> ..
>> Alternatively you go for read-modify-write (nasty performance hit
>> especially for RAID or a log structured fs).
> ..
> 
> Initially, at least, I'd guess that this NVM-HCI thing is all about
> built-in flash memory on motherboards, to hold the "instant-boot"
> software that hardware companies (eg. ASUS) are rapidly growing fond of.
> 
> At present, that means a mostly read-only Linux installation,
> though MS for sure are hoping for Moore's Law to kick in and
> provide sufficient space for a copy of Vista there or something.

Yeah... instant boot, and "trusted boot" (booting a signed image), 
storage of useful details like boot drive layouts, etc.

I'm sure we can come up with other funs uses, too...

	Jeff




