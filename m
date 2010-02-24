Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab0BXA0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 19:26:32 -0500
Received: from mail-iw0-f177.google.com ([209.85.223.177]:41765 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab0BXA0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 19:26:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AzR5qi1KAf/pYx5w2t7yxx83xx5UiYi5l1/k2oDwZ3y3Gu9IJ6ngRZCSn6FzfUF2i6
         /jOyB7+OjAsf6JKHD2dWJZlI3RKeWp3bV+lGYf/LIOFIT/Ab7293TZ5y4fLVhmisl3YT
         Bj7uC9yhfXrIEC8RwgvLlojU6BOpyRsR5Jo4Y=
MIME-Version: 1.0
In-Reply-To: <SNT125-W457447CBE941D2703E98D0C3420@phx.gbl>
References: <4B7CAF95.6020306@gmail.com> <20100218052223.GA13254@kroah.com>
	 <51f3faa71002181633w1649a648s37ae73da342d0c3f@mail.gmail.com>
	 <201002192139.46189.david-b@pacbell.net>
	 <51f3faa71002192315ia84786eo1138bf9ab3417f2d@mail.gmail.com>
	 <SNT125-W457447CBE941D2703E98D0C3420@phx.gbl>
Date: Tue, 23 Feb 2010 18:26:29 -0600
Message-ID: <51f3faa71002231626q1eb62adeo660c282418f0e01@mail.gmail.com>
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
From: Robert Hancock <hancockrwd@gmail.com>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Cc: david-b@pacbell.net, greg@kroah.com, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 12:48 AM, Yuhong Bao <yuhongbao_386@hotmail.com> wrote:
>
>> According to one Microsoft page I saw, Windows XP did not implement
>> the 64-bit addressing feature in EHCI. I haven't found any information
>> on whether any newer Windows versions do or not.
> Windows 7 seems to support it, and it seems like they have to already do a workaround for broken NVIDIA chipsets:
> http://support.microsoft.com/?kbid=976972
> http://www.windows7tipsonline.com/USB_Problem.htm
> http://social.technet.microsoft.com/Forums/en-US/w7itprohardware/thread/3aae3b66-6a1a-47e8-ad1b-b20b68eaecf8#79ea3219-d76e-40bc-b910-c7d347002e66
> http://social.technet.microsoft.com/Forums/en-US/w7itprohardware/thread/38f25c1d-de67-4c74-8845-2cd3a15d8e41

That's good news actually.. it means they've apparently already
debugged the feature for us :-) I suppose the next step would be to
contact NVIDIA and see what they say (i.e. which particular chipsets
have the problem), but from my experience with them, requests of the
form "can you confirm X is a bug in your chipset" to those guys seem
to go into the bit bucket. Does anyone have any good contacts at
NVIDIA for USB or other chipset issues? I see there's some existing
NVIDIA-specific EHCI quirks so I'm assuming someone was in contact
with them before..

The fact that Windows 7 is now using the feature also means that there
aren't likely to be too many machines where the 64-bit addressing is
reported but doesn't work. Which means that aside from the NVIDIA
quirk, I think enabling 64-bit addressing should be relatively safe.
