Return-Path: <linux-kernel-owner+w=401wt.eu-S1752130AbZHJHba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbZHJHba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 03:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZHJHb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 03:31:29 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:28629 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZHJHb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 03:31:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JzAgins5nMcN/wv1aM2JAOPakzJiu2M89WKZCCFG5h8cePzliXao2zTHQZz6W6PHnx
         MlLkpNsqIj/P/41bHd6V8vR6PUXVaN9IViUAbdkgnRzr6vMn38BcZpbcl6HFIC/HofoW
         O1aDo6qSR+n+Dns+vBUykgXCCHlTlLIpLpMZM=
MIME-Version: 1.0
In-Reply-To: <20090808214454.GB24153@elf.ucw.cz>
References: <20090808130315.GA12930@elf.ucw.cz>
	 <5d5443650908080942l50d91d31qb23c494affdf6850@mail.gmail.com>
	 <20090808214454.GB24153@elf.ucw.cz>
Date: Mon, 10 Aug 2009 13:01:28 +0530
Message-ID: <5d5443650908100031t5240daa4h76ef2a7863cc4403@mail.gmail.com>
Subject: Re: HTC Dream for staging: add support for input on GPIO pins
From: Trilok Soni <soni.trilok@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
       swetland@google.com, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Sun, Aug 9, 2009 at 3:14 AM, Pavel Machek<pavel@ucw.cz> wrote:
> On Sat 2009-08-08 22:12:46, Trilok Soni wrote:
>> Hi Pavel,
>>
>> On Sat, Aug 8, 2009 at 6:33 PM, Pavel Machek<pavel@ucw.cz> wrote:
>> > From: Arve Hj?nnev?g <arve@android.com>
>> >
>> > Support for input devices connected to GPIO pins. This adds support
>> > for HTC Dream's keyboard and its trackball. Generic support already
>> > exists for keyboard on GPIO, but this one is more advanced because it
>> > can detect shadow key presses (and actually works with Dream :-).
>> >
>> > (It also contains Kconfig/Makefile changes, including some that were
>> > missing from previous commit. Sorry.)
>>
>> I don't see any importance of gpio_matrix.c when we already have
>> generic gpio matrix driver mainlined. I would suggest to remove those
>> bits from this patch. I have added linux-input ML.
>
> Well, I'm trying for staging merge at this point. Reasons why
> gpio_matrix is there are:
>
> 1) it is non-trivial to remove
>
> 2) it has some features mainline lacks
>
> 3) HTC Dream actually works with it
>
> (and 4) I'd like to submit code as Arve wrote it, then transform/clean
> it up in staging).
>
> Of course, relevant features will need to be extracted from
> gpio_matrix and merged at the right places, and that needs to happen
> before move from staging/, but I'd like to have working keyboard in
> the meantime.

gpio_matrix in mainline should work with HTC G1 with few proper
platform data and input name eventhough ghost key clearance code is
not yet in mainline driver.

I know you want HTC dream to work through staging but I would prefer
that such drivers should be discussed and reviewed on
linux-input/linux-kernel ML and not just dumped in staging.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
