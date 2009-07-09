Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbZGIKra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbZGIKra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758842AbZGIKrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:47:21 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62376 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZGIKrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:47:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cRdKw5fpyAbeMWU9vwDJtXcMj0csC3f1nAfwQQqTyc1T4nhejcqBRPk+AFgdUMdRiO
         r+WJFSUTECf9DVt6XbfVlb4v4UBYQjDwYnmTKYrQ/i/1zqjxN0v574gFCuHeCJUlA74I
         LrjXA5Z0WqX3256KWiQuNh0OkQjlpjkMZg7/w=
MIME-Version: 1.0
In-Reply-To: <4A5575C1.8090403@lwfinger.net>
References: <4A54FB81.30302@gmail.com>
	 <3ace41890907081449m3ad6c4fdt55781848eedaec1e@mail.gmail.com>
	 <4A551B43.3020104@gmail.com>
	 <3ace41890907082118h52764c98i7ebd9365bcd69b2c@mail.gmail.com>
	 <4A5575C1.8090403@lwfinger.net>
Date: Thu, 9 Jul 2009 11:47:18 +0100
Message-ID: <3ace41890907090347m1f337731rb09b90327664ed5@mail.gmail.com>
Subject: Re: [PATCH] wireless: fix supported cards for rtl8187
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Linux wireless <linux-wireless@vger.kernel.org>,
       Przemyslaw Kulczycki <azrael@autocom.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/9 Larry Finger <Larry.Finger@lwfinger.net>:
> Hin-Tak Leung wrote:
>>
>> if they are not labelled v1/v2/v3 as such, it may be more
>> useful/informative to change to
>>
>>     [some variant of ] ... [(other variants are supported by the
>> rt2070/rt3070 modules)]
>>
>> instead of just adding [v2] to the end.
>
> I don't know about the box as I bought mine used on Ebay, but the
> label on the device clearly states that it is a WG111v2.
>
> Larry
>
>

But that's  a Netgear WG111v2 ? We are talking about Linksys
WUSB54GC-EU and its v1/v2/v3 . I am just thinking that if it is for
informative purposes (for those who actually selectively build their
kernel modules), adding a bit more info, such as suggesting to use
rt73usb/rt2070/rt3070 modules, won't hurt.

Incidentally I like to know a bit more about this patch - presumably
Marcin has such a device? I am also a little curious, as this commit
should be accompanied by a corresponding update in another Kconfig
which supports the device? I am not trying to be picky, but for an
informative (non-code-changing) patch, it can be more informative.
