Return-Path: <linux-kernel-owner+w=401wt.eu-S1762109AbYA3X7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109AbYA3X7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbYA3X70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:59:26 -0500
Received: from crca.org.au ([67.207.131.56]:43572 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbYA3X7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:59:25 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <47A10F43.4030300@nigel.suspend2.net>
Date: Thu, 31 Jan 2008 10:58:59 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hibernate/suspend-to-disk: to turn power or not?
References: <47A0CD90.5080208@msgid.tls.msk.ru> <47A0EB65.1020505@nigel.suspend2.net> <47A10A4F.3060203@msgid.tls.msk.ru>
In-Reply-To: <47A10A4F.3060203@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael.

Michael Tokarev wrote:
> Nigel Cunningham wrote:
> []
>> That should be doable. How is your UPS connected? Presumably, with some
>> modifications to the appropriate driver, we could send the commands when
>> we're ready to shutdown. It would probably be useful whether or not your
>> hibernating (if not, sending the commands could always be made an option).
> 
> You mean adding stuff to some KERNEL driver?  Like to a serial driver if
> the UPS is connected to a COM-port??
> 
> I'm afraid either I don't understand what you're talking about here, or,
> if I got you right, that YOU don't understand what you're talking about...
> 
> Come on, teaching kernel about various idiotic UPSes out there is more
> than insane... ;)

I wasn't meaning the kernel should have to know about various idiotic 
UPSses (yes, I've got experience with them too, so I understand what 
you're talking about there). What I was thinking was that maybe it might 
be possible to give the kernel some simple (configurable) string to send 
out the UPS port when it's time to power off. Of course you're going to 
point out that a simple string won't do in every case (though I think it 
would do for at least some of the idiotic UPS ones).

I was just wondering aloud if there was a simpler way, but on further 
reflection, I guess there's no way around it. Whether this is done with 
kexec, uswsusp or TuxOnIce, it's going to involve creating (TuxOnIce / 
kexec ) or extending a userspace (uswsusp) binary that's got to somehow 
interface with the driver and get the job done.

Nigel
