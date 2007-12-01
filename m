Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbXLAWq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbXLAWq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 17:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbXLAWqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 17:46:11 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:59230 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbXLAWqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 17:46:09 -0500
Message-ID: <4751E427.9000704@garzik.org>
Date: Sat, 01 Dec 2007 17:45:59 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, akpm@osdl.org
Subject: Re: [PATCH] libata: Fix early use of port printk. (Was Re: ata4294967295:
 failed to start port (errno=-19))
References: <Pine.SOC.4.64.0711281947090.15823@math.ut.ee>	<20071128200716.14eccfdd@the-village.bc.nu>	<Pine.SOC.4.64.0711301433130.13468@math.ut.ee> <20071130152316.32e2effa@the-village.bc.nu>
In-Reply-To: <20071130152316.32e2effa@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 30 Nov 2007 14:34:11 +0200 (EET)
> Meelis Roos <mroos@linux.ee> wrote:
> 
>>> Can you stick a stack trace in at that point ? That would help diagnose
>>> it a great deal quicker.
>> Finally done - found out hard way that BUG() is too bad and 
>> dump_st5ack() suits me better.
> 
> Thanks. This should fix the real cause, and also allow for port start to
> fail politely with -ENODEV.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

applied #upstream-fixes


