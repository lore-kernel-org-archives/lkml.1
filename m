Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYISXNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYISXNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYISXNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:13:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:17806 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbYISXNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=XiP9cm2CbfSKRbcjOUEjBK0xPQPxXCI7h+5l85Wtg70rj7oq3Zah8wUrx5rKvFVaRY
         6cgWUUd59MqOmIffkeRTq5Va7VUsx/cpkPjpzuADNx4eur1bOsLTEN0v3EEPLISYfbEw
         xk9xc0JhJnizmhT71TmPmUnjBqHcaeXcjMWXI=
Message-ID: <70318cbf0809191613u19ecc807j8911bc9a4ada50a2@mail.gmail.com>
Date: Fri, 19 Sep 2008 16:13:21 -0700
From: "Chris Li" <lkml@chrisli.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: irq 19: nobody cared
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080919233808.64aa7539@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
	 <20080919233808.64aa7539@lxorguk.ukuu.org.uk>
X-Google-Sender-Auth: 0ea8e11a306583ce
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 3:38 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> It could also be an IRQ being routed wrongly or an incorrect BIOS table
> so that the kernel is looking for the IRQ in the wrong place.
>
> Does booting with the irqpoll option help ?

Yes, booting with irqpoll option does helps with the latest kernel.
There is not such message appear any more. However I do want
the kernel fix this problem. The very same problem prevent me from
installing a FC8 live CD on this slim tower. In that FC8 kernel,
irqpoll does not help. BTW, it was working fine on FC7 kernel.
Upgrade to FC8 complete ruined it.

There are other user dell slim tower user report the same
problem on the Internet. One of the work around mention on the
internet is to change BIOS setting for SATA from "IDE"
mode to "RAID" mode. That tip complete destroy my partition
but  does not work for me any way. FC9 is better, at least
I am able to install with irqpoll.

I was hoping some one else already complain this on the lkml
and get it fixed. Guess not. So I am going my part then.

>> usb 4-2: new full speed USB device using uhci_hcd and address 2
>> irq 19: nobody cared (try booting with the "irqpoll" option)
>
> And does this last one (the irq19) occur immediately when you plug in a
> USB device ?

No,  the USB device is already (cold) plug to the system before the
kernel was booted. That new device message should be the first time the
USB driver detect the those USB device. I just load the kernel and
I did not hotplug any thing. It is the USB keyboard and mouse I think.

Any thing I can do to help to identify the problem?

Chris
