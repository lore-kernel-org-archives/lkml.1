Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbYKYIE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbYKYIE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYKYIEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:04:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:36583 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYKYIET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:04:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O03fqE010XER2fMmtcaj6PWiEyOCgbfEIZKhqwgzValYMshA+0YCHbkYPUW52Mebw/
         Xtl/PjJjD4Wm1uvpfO7z8CuVIaIesv6Fa9hb/5dljf+ZJ3/Af4mtBeHoKCtgaGIwSvJn
         1odN/6cebsD5I6nR7yhHBbX/3h2LOmSiiF6Aw=
Message-ID: <9b2db90b0811250004k5494cff7sfb22a91e0f6f6ab@mail.gmail.com>
Date: Tue, 25 Nov 2008 10:04:17 +0200
From: "Nir Tzachar" <nir.tzachar@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [PATCH] ncurses based config V2
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Willy Tarreau" <w@1wt.eu>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-kbuild@vger.kernel.org, ariveira@gmail.com, rdunlap@xenotime.net,
       kosaki.motohiro@jp.fujitsu.com, 7eggert@gmx.de
In-Reply-To: <Pine.LNX.4.64.0811250333060.13549@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220469076-16487-1-git-send-email-nir@tzachar.com>
	 <1220603220-17090-1-git-send-email-nir@tzachar.com>
	 <20080905195930.GA27913@1wt.eu>
	 <20081124184428.GA17085@uranus.ravnborg.org>
	 <Pine.LNX.4.64.0811250333060.13549@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Tue, Nov 25, 2008 at 4:33 AM, Roman Zippel <zippel@linux-m68k.org> wrote:
> Hi,
>
> On Mon, 24 Nov 2008, Sam Ravnborg wrote:
>
>> >   - colors are too dark.
>> Seconded. Please try to find a lighter set of default colors.
>> You may be inspired by one of the menuconfig color-sets.
>>
>> I agree that we could use a lift here - so please do not go for the
>> default color set of menuconfig.
>
> Well, the current colors seems to usable on wide variety of terminals, but
> I'm not colorblind, so I can't really complain. :)
> Before we keep discussing the colors, I'd rather suggest to drop them
> completely and maybe use colors for what actually needs attention.

The idea is using colors to give it a more modern look. Dropping
colors will bring us back to the "dark ages"...

>> >   - I'm not convinced that the parenthesis around hotkeys make the menu
>> >     that much readable, especially when there are lots of short words or
>> >     even acronyms. Eg :
>> >         [ ]   (U)TS namespace
>> >         [ ]   (I)PC namespace
>> >         [ ]   (U)ser namespace (EXPERIMENTAL)
>> >         [ ]   (P)ID Namespaces (EXPERIMENTAL)
>>
>> This looks like some ancient stuff and it must be a better way to
>> show the short-cuts.
>
> The parenthesis make it really annoying to read...

I agree. See my earlier response to Sam.

>> I would really appreciate if you could look into the above issues.
>> If you do a repost with this fixed I will try to do a proper review,
>> including code-review next time.
>
> The code is rather large, so it might be better to split the code into two
> sources, one for kconfig logic and the other for the interface logic, so
> it becomes easier to read and maintain.

Ok.

Thanks for your interest.
Cheers.
