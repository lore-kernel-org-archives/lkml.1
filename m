Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZELQPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZELQPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZELQPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:15:46 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49400 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbZELQPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:15:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wz5/Jh7UWXmW5RuFY5aM5AuKHJ+BZ+ScS/VOnaTENFT/C1shsDWENMK0iaTe7o5y9P
         C2blnALNyk4orbH/992VNY0vYAd7t0BSgqZ36mHIuOXL4D9YQjLvTZ6gEQg0PKgSSFnr
         FmiW/WqebzJnQRzU9EE5D4cgONccb3Tdr93os=
MIME-Version: 1.0
In-Reply-To: <1242031614.3384.10.camel@localhost.localdomain>
References: <6dd519ae0905080528j79640bb0l8fe475b2f09e6bc4@mail.gmail.com>
	 <1241821498.4903.69.camel@localhost.localdomain>
	 <6dd519ae0905110030n2abd87c0j507e476fb5622d87@mail.gmail.com>
	 <1242031614.3384.10.camel@localhost.localdomain>
Date: Tue, 12 May 2009 19:15:45 +0300
Message-ID: <6dd519ae0905120915s5dc1f4b9h8c0b80a243f9cf7f@mail.gmail.com>
Subject: Re: Regression: Problem in using USB Bluetooth Dongle (Worked fine in 
	2.6.24.x)
From: Brian Marete <bgmarete@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 11:46 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Brian,
>
>> >> At least until kernel version 2.6.24, I was able to use my USB
>> >> bluetooth dongle to download contacts from my phone. I made a jump
>> >> from 2.6.24 to 2.6.27, so I am not sure exactly which kernel version
>> >> starts the problem, but all kernels from the latter (2.6.27) now do
>> >> not work. The latest kernel I have tested is 2.6.29.2.
>> >
>> > can you test 2.6.30-rc4 or bluetooth-testing.git. I am pretty sure that
>> > whatever broke in 2.6.27 has been fixed by now. Some cheapo USB dongles
>> > behaved wrongly and it was a long time not clear what caused it.
>>
>> Alas, the regression is still there in 2.6.30-rc5 which I tested over
>> the weekend.
>>
>> I also forgot to mention that, even with the kernels with the
>> regression, device pairing using the dongle still works.
>>
>> Would a packet capture (usbmon) help? Willing to capture whatever
>> other debugging data that you think may help
>
> if device pairing works fine, the I guess this is a different problem.
> It could be that your USB host controller doesn't like the device. Or
> you forgot to load the EHCI driver or something. Otherwise your dongle
> should work fine. Since pairing works, what does hciconfig -a says?
>

Hello,

EHCI is actually loaded. See my regression report in my original email.

Regarding some conflict with the host controller, well, it did work
fine in 2.6.24.

Is there some other debug output I can collect or some other
information that I can provide to help identify the source of the
regression?

Thanks.


-- 
B. Gitonga Marete
Tel: +254-722-151-590
