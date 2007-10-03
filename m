Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbXJCRyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbXJCRyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXJCRyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:54:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37674 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbXJCRyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:54:37 -0400
Message-ID: <4703D75B.6070608@garzik.org>
Date: Wed, 03 Oct 2007 13:54:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mike Robak <mrobak@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: libATA error message doc
References: <2b40bfd30710031039y70252a8bk898b102c993a92af@mail.gmail.com>
In-Reply-To: <2b40bfd30710031039y70252a8bk898b102c993a92af@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Robak wrote:
> Does a doc exist that provides a detailed description of the different
> errors that could be produced by libata and its associated drivers?
> The libATA developer's guide provides a very good general description
> of the types of messages, but I'm looking for more detail.
> 
> For example I got this error message last week:
> 
> Sep 27 17:29:26 server kernel: ata2.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x1
> Sep 27 17:29:26 server kernel: ata2.00: (irq_stat 0x40000001)
> Sep 27 17:29:26 server kernel: ata2.00: tag 0 cmd 0xb0 Emask 0x1 stat
> 0x51 err 0x4 (device error)
> 
> I'd like to know what the following items means?
> 
> (irq_stat 0x40000001)
> tag 0
> cmd 0xb0
> emask 0x1
> stat 0x51
> err 0x4

It's pretty much all defined in the ATA or controller specifications...

Well, except for emask, which is a libata-only invention.

	Jeff



