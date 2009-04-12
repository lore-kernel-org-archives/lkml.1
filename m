Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbZDLB7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbZDLB7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 21:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbZDLB7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 21:59:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35160 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878AbZDLB7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 21:59:14 -0400
Message-ID: <49E14AE4.7010505@garzik.org>
Date: Sat, 11 Apr 2009 21:59:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <49E0D47B.9070205@garzik.org> <20090411203246.513a0892@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0904111250370.4583@localhost.localdomain> <da824cf30904111449y5cb7c178ldf5291506ad6b393@mail.gmail.com> <20090412002527.631a5a89@lxorguk.ukuu.org.uk> <49E12D03.5070906@garzik.org> <alpine.LFD.2.00.0904111725570.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904111725570.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> And maybe I'm wrong, and NTFS works fine as-is with sectors >4kB. But let 
> me doubt that.

FWIW...  No clue about sector size, but NTFS cluster size (i.e. block 
size) goes up to 64k.  Compression is disabled after 4k.

	Jeff



