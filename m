Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbYJSTht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbYJSTht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 15:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYJSThk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 15:37:40 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:60768 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYJSThj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 15:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MUAwiG6yr7ZacIqOll2up8oW5X7GO5jyRRJ0Mf2fJAPZNHzZIdCzmagDHnIY+wNpra
         Ve2jIAH3bubZN68QW9+qsxNg7ajnaxgjagK+68mKxnWq8eNNb06pmQ0UbloIXY6KXXJj
         +2+Opp/kQu2zhjEOF9xlO+EyRD3/vroIOdtCg=
Message-ID: <bc64b4640810191237w25027b68ra77bca03c64f8669@mail.gmail.com>
Date: Sun, 19 Oct 2008 23:37:38 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [GIT PATCH] USB patches for 2.6-git
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081019172901.GA22681@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081017220027.GA3659@kroah.com> <gdfauh$hsp$1@ger.gmane.org>
	 <20081019172901.GA22681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/19 Greg KH <greg@kroah.com>:
> On Sun, Oct 19, 2008 at 12:58:57PM +0000, Dmitry Baryshkov wrote:
>> Greg KH wrote:
>>
>> > Here is the big batch of USB patches for your 2.6-git tree.
>> >
>> > These paches are:
>> >     - a few new USB drivers.
>> >     - new device ids
>> >     - lots of bugfixes
>> >     - additions to the USB api to make driver writer's lives easier. -
>> >     removals of usb macros that don't make sense to use anymore
>> >       (warn() and info() should be using dev_warn() and dev_info()).
>> >     - other minor things.
>> >
>> > All of these patches have been in the -next and -mm trees for quite a
>> > while.
>>
>> >
>> > Please pull from:
>> >     master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/
>> >
>> > The full patches will be sent to the linux-usb mailing list, if anyone
>> > wants to see them.
>> >
>>
>> What about TMIO OHCI driver? Will it be merged during this merge window?
>
> That patch was dropped as it was causing a build error :)
>
> Now with the fix, I can add it back, I just need to merge it into the
> original.  It's in my queue and should go in soon.

OK, thank you. I was just worried if the patch was lost or just postponed :)

-- 
With best wishes
Dmitry
