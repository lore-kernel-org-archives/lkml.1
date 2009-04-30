Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbZD3XiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbZD3XiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZD3Xhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:37:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53946 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbZD3Xhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:37:50 -0400
Message-ID: <49FA3606.50808@garzik.org>
Date: Thu, 30 Apr 2009 19:36:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Artem Bityutskiy <dedekind@infradead.org>,
       Jared Hulbert <jaredeh@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <alpine.LFD.2.00.0904120820410.4583@localhost.localdomain> <6934efce0904141052j3d4f87cey9fc4b802303aa73b@mail.gmail.com> <1239777470.3390.164.camel@localhost.localdomain> <20090430225153.GA14784@logfs.org>
In-Reply-To: <20090430225153.GA14784@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> But like it or not, the market seems to be moving in that direction.
> Which means we will have "block devices" that have all the interfaces of
> disks and behave much like flash - modulo the crap FTL.


One driving goal behind NVMHCI was to avoid disk-originated interfaces, 
because they are not as well suited to flash storage.

The NVMHCI command set (distinguished from NVMHCI, the silicon) is 
specifically targetted towards flash.

	Jeff


