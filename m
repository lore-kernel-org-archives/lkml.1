Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXCVOh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXCVOh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 10:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933010AbXCVOh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 10:37:56 -0400
Received: from hoppetossa.avesi.com ([208.239.169.21]:54364 "HELO
	hoppetossa.avesi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933024AbXCVOhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 10:37:55 -0400
Message-ID: <460294CB.6060909@avesi.com>
Date: Thu, 22 Mar 2007 10:38:03 -0400
From: Christopher Mulcahy <cmulcahy@avesi.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Vincent Jorrand <vjorrand@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: sata_nv exceptions in 2.6.20.3
References: <756092.42594.qm@web31805.mail.mud.yahoo.com>
In-Reply-To: <756092.42594.qm@web31805.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Robert Hancock thought this was a hardware problem.
He was right.

I switched around cables on the hot-swap backplane, figuring that I 
would determine whether I had a bad cable or a bad backplane ( hoping 
for a bad cable ) and the problem went away.   One of the cables wasn't 
seated properly apparently.  ( It was a tight 1U box with very 
aggressive twist-ties that I had to cut to switch them around, so this 
wasn't immediately obvious.

I would make sure that all cables are seated properly, and try a 
different cable if the problem persists.

Vincent Jorrand wrote:
> I saw your email in the kernel dev mailing and I think I have the same problem, but since I am not a kernel developer, or running the bleeding edge kernels, I was not sure whether it was appropriate for me to post on the list.
>
>
>
>   My hard drive is a Seagate Barracudas ( 7200.10, 750GB, ST3750640AS ), very similar to yours. It is brand new (less than a month old)
> I also get the:
>      CPB flags CMD err, flags-0x11
> error in /var/log/messages.
>
> I am running kernel 2.6.20-1.2925.fc6
>
> Did you figure out a way to fix the problem?
>
> Vincent
>
>
>
>
>
>
>
>   

