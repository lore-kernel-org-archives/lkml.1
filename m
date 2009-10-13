Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbZJMPQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbZJMPQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760214AbZJMPQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:16:41 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:56063 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760206AbZJMPQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eoG2h2DaSoPzuXxBwAR6Zd6CYKfJfJvq/uEB9MIuiGtdAHo+8VT0lgA1gvJA6TWcrM
         2DBgdnlK0pigX0Gt6jO7eQsEXpKjkrYcDonrdsdSy/3QVeE8FoMf7hQhEYCWAZSltBGd
         4gLA/L/xLvc0th52+MUw1OtJ9aYAq/ocloa3g=
Message-ID: <4AD499BA.6030001@gmail.com>
Date: Tue, 13 Oct 2009 08:16:10 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Nix <nix@esperi.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       =?ISO-8859-1?Q?=22Fr=E9d=E9ric_L=2E_W=2E_Meunier=22?= 
	<fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>	<L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>	<C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>	<87ljjgfcbu.fsf@spindle.srvr.nix>	<alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>	<alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>	<4AD3F769.5080405@gmail.com> <20091013113434.22f4fcde@lxorguk.ukuu.org.uk>
In-Reply-To: <20091013113434.22f4fcde@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I can throw your patch in over here for the heck of it.
>> If there's somebody who's really hitting this bug
>> then the results would be better  if this is the area that causing
>> this bug.(from here the only issue I'm seeing is spinning
>> history commands in the terminal  from time to time,
>> nothing of any unusable keys like others are reporting).
>>      
>
> That sounds more like a lost key-up event somewhere higher up the stack.
> USB keyboard ? and does it stop if you take the key in question. Also does
> it stop if you touch the mouse wheel (assuming you've got mousewheel
> bound to shell history somewhere ?)
>
> Alan
>
>    
This seems like it's a new mechanism with
fedora/ubuntu, but could be wrong.
(smart keys or something)

It is a usb keyboard using evdev/keyboard
as the X modules to operate.(imac9,1)
The way I've been able to get this to stop is
open another terminal, then when the history starts
spinning like it does click on the other terminal,
and everything seems to stop.
As for reproducing this thing seems to have a mind of it's own, some timers
firing off to tell it to start searching for the last good word for the 
"user",
(but could be wrong)that ends up being something completely wrong,
although a couple of times it did actually work and go right to the word 
I had in mind,
but most of the time this things just causes irritation.


Justin P. Mattock

