Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZI1Byx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZI1Byx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 21:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZI1Byw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 21:54:52 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:37377 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZI1Byv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 21:54:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nUw1ovnjqYqs8K/+lCYl+k3BPQC5antcWPwIeu8Opk6EnEBcPxQr4SjeH7c2uXKE6z
         Yp4tAiKhx0NtDUNFxgjvQAj0tvQEwMq83jiwvmb6NetGv0YfLdLnqB0XAXT0CKyXk0IS
         uSg/Ic+T6RJM2cSKsl9feqk7W2cEsYTFh7Za0=
MIME-Version: 1.0
In-Reply-To: <8db1092f0909270916k79d0c369ub93b5e8ddf66c979@mail.gmail.com>
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
	 <2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
	 <2674af740909270130h359a5d23taa7e8b63e6a18a4d@mail.gmail.com>
	 <8db1092f0909270325j67825cem82fc93cf19336d6f@mail.gmail.com>
	 <2674af740909270701u6febabdbpc5c772fabc193b32@mail.gmail.com>
	 <2674af740909270749u339671a1ia81d5736eeb750fa@mail.gmail.com>
	 <8db1092f0909270916k79d0c369ub93b5e8ddf66c979@mail.gmail.com>
Date: Mon, 28 Sep 2009 09:54:54 +0800
Message-ID: <2674af740909271854v191d9768mc3d96f30998f8c01@mail.gmail.com>
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 
	hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 
	__sysdev_resume+0xc3/0xe0()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, gregkh@suse.de, zambrano@broadcom.com,
       davem@davemloft.net, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 12:16 AM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> 2009/9/27 Yong Zhang <yong.zhang0@gmail.com>:
>>
>> It seem this is cause by b44 dirver. Can you give a try?
>>
>> From 05ee2f22a7ea065e05bf8b5294d222a3700d2cc8 Mon Sep 17 00:00:00 2001
>> From: Yong Zhang <yong.zhang0@gmail.com>
>> Date: Sun, 27 Sep 2009 22:42:41 +0800
>> Subject: [PATCH] net/b44: keep irq state at suspend_resume
>>
>> suspend() and resume() assume irq is disabled. So keep the irq
>> state when do this.
>
> Remove previous patch, add it to clean 2.6.31-git17. It doesn't help.
>
>> --
>> 1.6.0.4
>>
>>> So can you test the follow patch. And show the dmesg info(DEBUG
>>> level) after WARNING is triggered?
>>>
>>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>>> index fb0f46f..4a00a1a 100644
>
> Still test it?
>

If you could, then please do it. It can give us some helpful information.

Thanks,
Yong

> Regards
> --
> Maciej Rutecki
> http://www.maciek.unixy.pl
>
