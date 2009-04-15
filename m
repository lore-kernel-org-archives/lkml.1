Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbZDOCtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbZDOCtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZDOCsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:48:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49476 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZDOCsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:48:54 -0400
Message-ID: <49E54B12.8040303@garzik.org>
Date: Tue, 14 Apr 2009 22:48:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
References: <49E4FAC6.1030400@garzik.org>	<20090414183807.3baf72ed@infradead.org>	<49E546C4.1060001@garzik.org> <20090414194414.22c63728@infradead.org>
In-Reply-To: <20090414194414.22c63728@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 14 Apr 2009 22:30:28 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Arjan van de Ven wrote:
>>> This change just made it go faster enough for you to be out of luck;
>>> fundamentally your userland needs to wait if the device it wants is
>>> not there. 
>> All these drivers are in-kernel, and the root device is passed via 
>> command line.  There is no userland at that point, that needs to wait.
> 
> ok fair; but that does not change that the kernel does not know if a
> device is coming.
> Yes that sucks; sadly USB is just this way, you don't know when no new
> devices will come from a certain bus.

Perhaps -- but I can say that kernels <= 2.6.27 booted with 100% 
reliability.

Now, Kernels >= 2.6.28 always fail.

The ONLY variable is the kernel.

	Jeff



