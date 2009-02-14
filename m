Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbZBNWCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbZBNWCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZBNWB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:01:57 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:3732 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbZBNWB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:01:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=ehMkoGcpoST+rHQJJzI3WSbLAoiTRxU4vyvuQZ4/yA8t/PNBJtxB1jMaNg+sE9YeZZ
         Rq6w8coMK/iaqhNolXEbtxVEoDWUju9kLbh3RtOXVzU9bnWHyFYv54exrZKWzYp+l92z
         lEhSN5W4x6WhPrrOY7eGSLwMjmnpCCZQNOtNs=
Message-ID: <49973F4F.1010804@gmail.com>
Date: Sat, 14 Feb 2009 16:01:51 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Serguei Miridonov <mirsev@cicese.mx>
CC: linux-kernel@vger.kernel.org
Subject: Re: Intel ICH9M/M-E SATA error-handling/reset problems
References: <200902141206.06419.mirsev@cicese.mx>
In-Reply-To: <200902141206.06419.mirsev@cicese.mx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serguei Miridonov wrote:
> I have some problems with SATA in a new notebook PC (HP Pavilion dv5t, 
> Intel chipset). Seagate FreeAgent Pro 1TB external drive practically 
> can not be used with eSATA in Linux (fresh install from DVD Fedora 10, 
> now fully updated), and yesterday I also had problem with DVD 
> recording using internal HL-DT-ST BDDVDRW drive.
> 
> More details in attachment.
> 
> Both devices work with Windows Vista. Seagate external drive even in 
> Vista produces "parity error" messages in Windows event log but OS is 
> somehow recovering from these errors and continues to use the drive 
> with slight slowdown (average speed varies between 60 and 110 MB/s). 
> Of course, it could be cable/Seagate issue, but again - Vista can 
> handle this.

There are a lot of issues with eSATA drives and cabling. As Jeff 
mentioned, there are some changes in 2.6.29-rc that may improve the 
behavior, but the root cause here is a hardware issue (you should not 
expect very good behavior in Vista either with those errors).

As far as the DVD burning issue, it's hard to say for sure. It looks 
like a write command was timing out. Could be due to your drive not 
working well with that type of media.

> 
> It appears that Linux kernel has problems with error-handling/reset of 
> SATA hardware. I have found a lot of reports regarding SATA problems: 
> data transfer failures, CD/DVD recording, waking up from suspend to 
> RAM, etc. Aren't they all related? Can Linux SATA chipsets drivers 

Not related at all, mostly.. though a lot of people seem to think they 
are. Often times people think problems are related because the error 
messages seem similar, and even the same error can be triggered by 
numerous different problems, often not the fault of the kernel.

> properly reset hardware into predictable state? Sure, I could be wrong 
> and my issue may have nothing to do with others... Any idea?
> 
> Please, CC any reply to my e-mail.
> Thank you.


