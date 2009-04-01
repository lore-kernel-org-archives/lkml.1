Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZDAGfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZDAGfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 02:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbZDAGfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 02:35:34 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:42919 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbZDAGfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 02:35:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UYkMbYqQDms/4PinW0uOuzXRqjkOJwLij7t9ojzIJWI2QU70cvlCr11j1cy7dawwWD
         D6lTpZj3ULWUnaLiP3g0yTXS0WD5e9JZCS4tGWNNtTd07BXXuBCERZRsiwAwOVRvpE4T
         FRqM0/Ez6N9XfT89Sxec/XUB3ODRBJHda1bJ0=
MIME-Version: 1.0
In-Reply-To: <49D27072.8070504@zytor.com>
References: <804dabb00903302349j5bdbabeaxbbd09291b1cf6e4@mail.gmail.com>
	 <df9815e70903310147l1ae6675ag1fa4c2e99250cef4@mail.gmail.com>
	 <804dabb00903310151y2d091ef3u5bbef0c7a264cb29@mail.gmail.com>
	 <49D27072.8070504@zytor.com>
Date: Wed, 1 Apr 2009 14:35:30 +0800
Message-ID: <804dabb00903312335t660536a1pc029988c1f71f63a@mail.gmail.com>
Subject: Re: "make oldconfig" problem
From: Peter Teoh <htmldeveloper@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jike Song <albcamus@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 1, 2009 at 3:35 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Peter Teoh wrote:
>>>>
>>> Seems to be caused by
>>> 40297927575a50b1d0d308d735c445924d33fba6("bzip2/lzma: don't ask for
>>> compression mode for the default initramfs").
>>>
>>> I get no errors with that commit reverted.
>>
>> Thank you, will try that.
>>
>
> Linus complained about a choice that didn't make sense for most users.
> Unfortunately Kconfig doesn't seem to have a sane block to deal with having
> alternatives to conditionalized choice blocks.
>
> Fortunately, CONFIG_INITRAMFS_COMPRESSION_NONE doesn't actually *do*
> anything, so this is probably the preferred hack.
>
> Could you try this out?  If it works as expected for you as well as me, I'll
> push it to Linus.
>
>        -hpa
>
>

Yes, it worked for me, compiled fine and well.   Thanks.


-- 
Regards,
Peter Teoh
