Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbXJVVVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbXJVVVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 17:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbXJVVVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 17:21:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59904 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbXJVVVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 17:21:40 -0400
Message-ID: <471D145A.40904@garzik.org>
Date: Mon, 22 Oct 2007 17:21:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>	<1193076664-13652-10-git-send-email-jens.axboe@oracle.com>	<Pine.LNX.4.64.0710222137520.7105@anakin>	<alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org> <20071022211617.31f5c63d@the-village.bc.nu>
In-Reply-To: <20071022211617.31f5c63d@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Why can't we just make the list one item longer than the entry count and
> stick a NULL on the end of it like normal people ?

Certainly seems safer than the current "let's run off the end of the 
list if anything bad happens" setup...  And I do not think allocating 
n+1 scatterlist entries will have much of a negative impact.

	Jeff


