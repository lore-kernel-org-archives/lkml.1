Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZDLOXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZDLOXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 10:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZDLOXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 10:23:39 -0400
Received: from rtr.ca ([76.10.145.34]:37903 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbZDLOXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 10:23:38 -0400
Message-ID: <49E1F967.9090106@rtr.ca>
Date: Sun, 12 Apr 2009 10:23:35 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Grundler <grundler@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <49E0D47B.9070205@garzik.org>	<20090411203246.513a0892@lxorguk.ukuu.org.uk>	<alpine.LFD.2.00.0904111250370.4583@localhost.localdomain>	<da824cf30904111449y5cb7c178ldf5291506ad6b393@mail.gmail.com> <20090412002527.631a5a89@lxorguk.ukuu.org.uk>
In-Reply-To: <20090412002527.631a5a89@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
..
> Alternatively you go for read-modify-write (nasty performance hit
> especially for RAID or a log structured fs).
..

Initially, at least, I'd guess that this NVM-HCI thing is all about
built-in flash memory on motherboards, to hold the "instant-boot"
software that hardware companies (eg. ASUS) are rapidly growing fond of.

At present, that means a mostly read-only Linux installation,
though MS for sure are hoping for Moore's Law to kick in and
provide sufficient space for a copy of Vista there or something.

The point being, it's probable *initial* intended use is for a
run-time read-only filesystem, so having to do dirty R-M-W sequences
for writes might not be a significant issue.

At present.  And even if it were, it might not be much worse than
having the hardware itself do it internally, which is what would 
have to happen if it always only ever showed 4KB to us.

Longer term, as flash densities increase, we're going to end up
with motherboards that have huge SSDs built-in, through an interface
like this one, or over a virtual SATA link or something.

I wonder how long until "desktop/notebook" computers no longer
have replaceable "hard disks" at all?

Cheers
