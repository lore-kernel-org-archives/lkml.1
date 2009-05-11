Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbZEKHhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbZEKHhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 03:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZEKHhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 03:37:33 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:58463 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbZEKHhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 03:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BDFE7EswXVoR8Qo2y6dX4B75XGwdvfNiyjKaCz2WfUKIOyR7Xkl+ygQJdbXU6qsqWQ
         7GPao7NiCGMW9VRrmHEeXaFcyuHDAdqTBY7QT9HXCyqKWwvXgjORvQ11DqXY+/Gs2RuC
         8RzXXD4Q2KRfokmi6tYG7wAqsDcmVl2pIx6VA=
MIME-Version: 1.0
In-Reply-To: <1241821498.4903.69.camel@localhost.localdomain>
References: <6dd519ae0905080528j79640bb0l8fe475b2f09e6bc4@mail.gmail.com>
	 <1241821498.4903.69.camel@localhost.localdomain>
Date: Mon, 11 May 2009 10:30:14 +0300
Message-ID: <6dd519ae0905110030n2abd87c0j507e476fb5622d87@mail.gmail.com>
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

On Sat, May 9, 2009 at 1:24 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Brian,
>
>> At least until kernel version 2.6.24, I was able to use my USB
>> bluetooth dongle to download contacts from my phone. I made a jump
>> from 2.6.24 to 2.6.27, so I am not sure exactly which kernel version
>> starts the problem, but all kernels from the latter (2.6.27) now do
>> not work. The latest kernel I have tested is 2.6.29.2.
>
> can you test 2.6.30-rc4 or bluetooth-testing.git. I am pretty sure that
> whatever broke in 2.6.27 has been fixed by now. Some cheapo USB dongles
> behaved wrongly and it was a long time not clear what caused it.
>

Hello Marcel,

Alas, the regression is still there in 2.6.30-rc5 which I tested over
the weekend.

I also forgot to mention that, even with the kernels with the
regression, device pairing using the dongle still works.

Would a packet capture (usbmon) help? Willing to capture whatever
other debugging data that you think may help

Thanks.
-- 
B. Gitonga Marete
Tel: +254-722-151-590
