Return-Path: <linux-kernel-owner+w=401wt.eu-S933998AbZHHKNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998AbZHHKNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 06:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933940AbZHHKNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 06:13:54 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33021 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933934AbZHHKNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 06:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b5JqBofPp6CXGSDFuUOGpnh5Od3Pk7lkdi8Tq/Fh7+4GMh3Y0PwjeIQRlsTcN/pgKp
         NR7xqb1dM8XVoqZZtaSI+LP3g38/3Z+xSUJcCZsCRcpTOKxud0lztMJafkcBmIMlKmgF
         F6pXvP+ilpTD7rlv+TGHzhJdi4VVsLYljfbBQ=
MIME-Version: 1.0
In-Reply-To: <20090807094944.eed4bfb8.akpm@linux-foundation.org>
References: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
	 <20090807134659.GA2093@darkstar>
	 <20090807094944.eed4bfb8.akpm@linux-foundation.org>
Date: Sat, 8 Aug 2009 18:13:53 +0800
Message-ID: <a8e1da0908080313k65f51185u7329e293a95861a7@mail.gmail.com>
Subject: Re: mmotm 2009-08-06-00-30 uploaded
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 8, 2009 at 12:49 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> On Fri, 7 Aug 2009 21:47:00 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> Hi, andrew
>>
>> Booting with this release, init (maybe getty?) reports something like:
>>
>> INIT: open /dev/console failed with input/output error
>>
>> 2.6.31-rc5 is fine.
>>
>> Any hints to find the root problem?
>
> Not really, sorry.  Might be tty changes in linux-next?

I bisected linux-next, find following patch as a result

commit 65b8c7d9be5862ff8ac839607b444b6f6b11d2fb
Author: Alan Cox <alan@linux.intel.com>
Date:   Thu Aug 6 09:58:02 2009 +1000

    cyclades: use the full port_close function

But, I did not select cyclades in my .config, nor do i have the hardware. Weird.

>
>> Another problem:
>>
>> When I moving mouse or pressing key the screen will become black, then restore the normal screen.
>
> There have been quite a lot of X problems lately.
>
> Could you test the bare linux-next please?
>



-- 
Regards
dave
