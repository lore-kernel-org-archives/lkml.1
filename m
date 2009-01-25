Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbZAYVKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbZAYVKw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 16:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZAYVKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 16:10:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:47326 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbZAYVKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 16:10:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R7yMxXkGHXrFa4qUIRRwWmlcFu86xWn5hxEmCUtu7ygXxUwV0B3vQMt3z1yIghkppQ
         WqvndWO927/ImCBU0BHUOuNbx/0rar3XctPbZ3DjqAhQZFqIUd/H/3FJhmEwD1KQt6Yh
         yi3bIcEpN+capGTxkhH/SEfFxEvFlTz0ak1ew=
MIME-Version: 1.0
In-Reply-To: <497CD30D.80203@tmr.com>
References: <3f9a31f40901251239k3e368feeib33661d82497725b@mail.gmail.com>
	 <20090125204603.2ccb5169@lxorguk.ukuu.org.uk> <497CD30D.80203@tmr.com>
Date: Mon, 26 Jan 2009 02:40:42 +0530
Message-ID: <3f9a31f40901251310g38ecfe61t97e119533215d271@mail.gmail.com>
Subject: Re: hdb: status error: error=0x40 <3>{ UncorrectableError }
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 2:31 AM, Bill Davidsen <davidsen@tmr.com> wrote:
>
>
> Alan Cox wrote:
>>
>> On Mon, 26 Jan 2009 02:09:56 +0530
>> Jaswinder Singh Rajput
>> <jaswinderlinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> Hello all,
>>>
>>> I added extra IDE drive I get similar messages like below so I replace
>>> it another drive but I am still getting similar error messages on
>>> 2.6.29-rc2-tip:
>>>
>>> hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest
>>> Error }
>>> hdb: status error: error=0x40 <3>{ UncorrectableError },
>>> LBAsect=208845, sector=0
>>
>> Uncorrectable Error is an error from the drive, not the kernel. Looks
>> like you have bad sectors on that drive.
>>
> He noted that he tried another drive, so unless he has a pile of bad drives
> it's probably something else. Being "hdb" may indicate that it's connected
> to the same controller as "hda" and might not be jumpered for slave. Or it
> might be a bad cable, a controller which doesn't like two drives, a dubious
> power connector, etc. Or if he doesn't have an hda, perhaps the kernel
> doesn't like a secondary drive without a primary.
>
> Being hdb instead of sdb with a new kernel indicates he is using a config
> which may get a lot less testing these days, perhaps?
>
> In any case, I doubt he had two bad drives, so something else is more
> likely.
>

But earlier both was working fine on some another machines.

--
JSR
