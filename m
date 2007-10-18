Return-Path: <linux-kernel-owner+w=401wt.eu-S1763977AbXJRKug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763977AbXJRKug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbXJRKu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:50:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56584 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757305AbXJRKu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:50:27 -0400
Message-ID: <47173A69.3050808@garzik.org>
Date: Thu, 18 Oct 2007 06:50:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <20071018083213.GN5063@kernel.dk> <471720FE.4090004@garzik.org> <20071018091706.GO5063@kernel.dk> <4717281B.6070301@garzik.org> <20071018094128.GP5063@kernel.dk> <47172FB1.5020704@garzik.org> <20071018100959.GQ5063@kernel.dk> <20071018101348.GA29296@elte.hu> <20071018101650.GR5063@kernel.dk> <20071018101739.GS5063@kernel.dk> <20071018104910.GA9658@elte.hu>
In-Reply-To: <20071018104910.GA9658@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
>>> It would always be nice. For this case I don't think it's very 
>>> interesting, if we pursue the improved sg iteration setup.
>> BTW, I think it's pretty clear that ata_sg_is_last() is broken. It's 
>> likely a one-off in the n_iter test.
> 
> fixing that would be a -stable candidate, as a potential data corruptor 
> - or is it more benign?

It is confirmed working prior to the sg-chaining stuff, so 2.6.23.1 is OK...

	Jeff



