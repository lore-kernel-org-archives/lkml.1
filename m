Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZFCIev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZFCIev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbZFCIeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:34:44 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:37524 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbZFCIen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:34:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ibYxffmNfv9DvQhNEwpmPdrLwWY1pm6cyh+1H5xZQJgMsQ3CWOVWtUgLZOHnCScmxh
         oWJy1NzklcIsGcF37AuPPxepKIpmAXMqqS2TMN1Gs3pn/xcNlVzlhZxUpl4gUbudAoyz
         gffFqKvUhMS0l5T0dHQmUYYzrVaGYx+mO5pRo=
MIME-Version: 1.0
In-Reply-To: <20090603084253.1a0aa5b0@lxorguk.ukuu.org.uk>
References: <1243987469.20635.69.camel@centos51>
	 <20090603084253.1a0aa5b0@lxorguk.ukuu.org.uk>
Date: Wed, 3 Jun 2009 17:34:44 +0900
Message-ID: <49b7c2350906030134x4a911313x138b9775322d13cf@mail.gmail.com>
Subject: Re: [PATCH] Fix the meaning of EDAC abbreviation
From: GeunSik Lim <leemgs1@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Kosina <trivial@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 4:42 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Fix the meaning of EDAC(Error Detection And Correction) correctly.
>>  - http://bluesmoke.sourceforge.net
>>
>>         Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
>> ---
>>  drivers/edac/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
>> index 956982f..2a81915 100644
>> --- a/drivers/edac/Kconfig
>> +++ b/drivers/edac/Kconfig
>> @@ -5,7 +5,7 @@
>>  #
>>
>>  menuconfig EDAC
>> -     bool "EDAC - error detection and reporting"
>> +     bool "EDAC - Error Detection And Correction"
>
> The code started off as one thing and acquired its name but a primary
> function of it now is indeed reporting rather than just correction. The
Thank you for explanation and advice about EDAC meaning.

> name has stuck but the functionality doesn't quite match - so the
> existing menuconfig entry is actually more helpful.
Um.
How about  we change contents with "EDAC (Error Detection And
Correction) reporting"  to understand EDAC abbreviation normally?
This is Just my thinking.

Thks,


-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
