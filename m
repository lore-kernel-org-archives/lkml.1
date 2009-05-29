Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZE2BYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZE2BYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 21:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZE2BYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 21:24:31 -0400
Received: from mail-px0-f191.google.com ([209.85.216.191]:45430 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbZE2BYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 21:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GXbctrNHjit5UfDqOxlJu66OzyCmvHnCRSkBOv5me8nTXtSztnot0mH4W9LLX8FusL
         5UtgBrNQervi7Wem7xgIT3KlGCCmxjZaM3SIzh+d6pn3cu5OIx4fPmYgCPepAUvxhG+Y
         C4QV72Jhqnr0JwpRiNyLSXekIIQTUxVgTSo0E=
MIME-Version: 1.0
In-Reply-To: <20090528201450.GA4043@kroah.com>
References: <1243004787-5362-1-git-send-email-tom.leiming@gmail.com>
	 <20090522161016.36ef6f15@lxorguk.ukuu.org.uk>
	 <d82e647a0905220826p378f6bb4vac9150343b5c3622@mail.gmail.com>
	 <20090528201450.GA4043@kroah.com>
Date: Fri, 29 May 2009 09:24:32 +0800
Message-ID: <d82e647a0905281824kd98e5c9re22b4c43e68d341e@mail.gmail.com>
Subject: Re: [PATCH] driver core : fix request_firmware_nowait
From: Ming Lei <tom.leiming@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/29 Greg KH <greg@kroah.com>:
> On Fri, May 22, 2009 at 11:26:16PM +0800, Ming Lei wrote:
>> 2009/5/22 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> > On Fri, 22 May 2009 23:06:27 +0800
>> > tom.leiming@gmail.com wrote:
>> >
>> >> From: Ming Lei <tom.leiming@gmail.com>
>> >>
>> >> request_firmware_nowait declares it can be called in non-sleep contexts,
>> >> but kthead_run which is called by request_firmware_nowait may sleep.
>> >
>> > Does anyone actually need to call it in a non-sleeping context or can the
>> > documentation simply be fixed instead to avoid all the extra complexity ?
>> >
>>
>> It seems no one calls it in a non-sleeping context now, but we can provide it
>> without much extra complexity, IMHO.  Also someone has complained it :
>>
>>       http://marc.info/?t=124022846400003&r=1&w=2
>
> That was 3 years ago :)

No, just one month ago, also the name of *_nowait is very misleading and only
documentation fix seems not enough,  right?

http://marc.info/?t=124022846400003&r=1&w=2

2009-04-20 Am I allowed to call request_firmware_nowait from an
linux-ker John Hughes

>
> I say just fix the documentation.
>
> thanks,
>
> greg k-h
>



-- 
Lei Ming
