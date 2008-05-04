Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbYEDMhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbYEDMhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbYEDMh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:37:26 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:29815 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbYEDMhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:37:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=l3TxaSg2bgWs+hevvfQnguIPUxU8gSn3GL3IINsCRTznbxUtLGuGpOJxLMm7sty7ZWqSDLwhOcrsfm8s9O766hoS7XDyJ3F3pnBUwkridwW6fI/l7bLpMLQANKOVnrC6EmfieBGUjzNQD9kMhI8CfNHCvuqCcv9QxiqNnv9SW8I=
Message-ID: <481DACEE.7020302@gmail.com>
Date: Sun, 04 May 2008 14:32:46 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Suspend to memory is freezing my machine
References: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com> <200805041240.52988.rjw@sisk.pl>
In-Reply-To: <200805041240.52988.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki pisze:
> On Sunday, 4 of May 2008, Zdenek Kabelac wrote:
>> Hello
> 
> Hi,
> 
>> With recent 2.6.25 & 2.6.26-rc1 git (around 1 week) I get occasionally
>> complete freeze of my T61 during suspend. (dual core, 2GB).
> 
> How reproducible is this?
> 
>> I'm running kernel with no_console_suspend - but all I can see is
>> blinking cursor on an empty screen - thus even when I run kernel with
>> most debug options turned on, I can't pass more details so far.  I run
>> suspend with with SD card in - so maybe some update in the MMC driver
>> might be responsible for this ?
>>
>> Also - I think that option no_console_suspend doens't work correctly -
>> as many times with suspend I do not see any log message on my console
>> screen. However sometimes the log is shown.
> 
> It would be helpful if you could verify if:
> 
> (1) The problem occurs without no_console_suspend.
> (2) The problem occurs without the SD card.
> 

Hi Rafael,

same problem here, although I was able to resume system (it's basically Intel
machine) , but it was unusable - I was able to switch between terminals and see
output from kernel. So there was:
	- Disabling irq #19;
	- some kind of lock spinning on disk:
IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA Storage
Controller IDE (rev 02)
	but I can't provide more output of that lock now - no sign in logs.

I've made some successful suspend/resume all without sound card active without
problem. Those appear with sound card active, but I must take closer look - will
send info later.

-Jacek
