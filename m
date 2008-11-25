Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbYKYIBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbYKYIBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbYKYIBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:01:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:32848 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbYKYIBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:01:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=r63nI9HJGhghQPtwU9hdOxkwMsAWMQ+10MEB3ehOQBv053IVL5o4n0W5IpWJmawglw
         yeKwfYc8Wy2uTWSm31GN7qJAPqjGj4JL9MIWgOWnZZjYKHHVukf9UbGCCwV+mzyYNUf/
         kdEEevpASeqyBlchpgC3RbYU28Ou1UzXv2lvI=
Message-ID: <9b2db90b0811250001k6e0c609frca073f3221a3e8ed@mail.gmail.com>
Date: Tue, 25 Nov 2008 10:01:19 +0200
From: "Nir Tzachar" <nir.tzachar@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] ncurses based config V2
Cc: "Willy Tarreau" <w@1wt.eu>, "Nir Tzachar" <tzachar@grad120a.cs.bgu.ac.il>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, ariveira@gmail.com, rdunlap@xenotime.net,
       kosaki.motohiro@jp.fujitsu.com, 7eggert@gmx.de
In-Reply-To: <20081124184428.GA17085@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220469076-16487-1-git-send-email-nir@tzachar.com>
	 <1220603220-17090-1-git-send-email-nir@tzachar.com>
	 <20080905195930.GA27913@1wt.eu>
	 <20081124184428.GA17085@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam.

On Mon, Nov 24, 2008 at 8:44 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> Hi Nir.
>
> Some comments as followup to Willy.
>
>> OK, I've just tried it. Here are the first comments I can make :
>>
>>   - colors are too dark.
> Seconded. Please try to find a lighter set of default colors.
> You may be inspired by one of the menuconfig color-sets.
>
> I agree that we could use a lift here - so please do not go for the
> default color set of menuconfig.

Personally, I like lighter text on a dark background. But this is just
me. I'll try to implement an easier color scheme chooser so everyone
will be able to play with it and come up with something they like.

>>   - entering text in boxes (eg: local version) does not move the cursor,
>>     it remains at the beginning of the line. If I press any arrow, the
>>     box immediately closes (most likely the Esc prefix again).
>

This is fixed in my current version (I have not subitted a patch yet)

> I do not see any cursor which is annoying. menuconfig has the same issue.

also fixed.

>>   - I noticed I was tempted a lot to press "?" to get help, but the key is
>>     not bound. It would be nice to have it bound to Help since make oldconfig
>>     and menuconfig to both report help that way.
>
> Please bound this.

consider it bounded..

>>   - I'm not convinced that the parenthesis around hotkeys make the menu
>>     that much readable, especially when there are lots of short words or
>>     even acronyms. Eg :
>>         [ ]   (U)TS namespace
>>         [ ]   (I)PC namespace
>>         [ ]   (U)ser namespace (EXPERIMENTAL)
>>         [ ]   (P)ID Namespaces (EXPERIMENTAL)
>
> This looks like some ancient stuff and it must be a better way to
> show the short-cuts.

This was the best I could come up with, as ncurses does not let you
use color attributed for menu items. I'll try a different scheme,
where the first capitalized letter is the shortcut. What do u say?

> I would really appreciate if you could look into the above issues.
> If you do a repost with this fixed I will try to do a proper review,
> including code-review next time.

Sure. I'll have a patch ready in a few days.
Cheers.
