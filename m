Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbZLGIcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbZLGIcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759188AbZLGIcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:32:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:13111 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160AbZLGIcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:32:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=um56MDcsP9MfFG1aJ77taEf3OsA8PKBY9OE0dELFOvisKLXdinaZR1MAw3OqJbqCtK
         dE8RF6mCzuAlOIoiYQnjYvFXZJwjiqrZkT4LFoUgpxBoJKeGMwNP98t5t2G0QRZht6V1
         A/c4HYZJjmh6LjboMe0QWBEk4dIuCoBhkazoU=
MIME-Version: 1.0
In-Reply-To: <4B1C38B5.2060204@tremplin-utc.net>
References: <40a4ed590911190052w63a18bb7p516a5e759e0ffa23@mail.gmail.com>
	 <4B055609.9030306@tremplin-utc.net>
	 <4B1A53AE.9020707@tremplin-utc.net>
	 <40a4ed590912060741n4042ab1bg8188cd4eff28ca78@mail.gmail.com>
	 <4B1BDAA3.10601@gentoo.org>
	 <40a4ed590912060835s61aea6aqfe6780395bfd2993@mail.gmail.com>
	 <4B1C38B5.2060204@tremplin-utc.net>
Date: Mon, 7 Dec 2009 09:32:19 +0100
Message-ID: <40a4ed590912070032h110fc965l5756822799ad8b29@mail.gmail.com>
Subject: Re: Intel Poulsbo [psb] driver for Asus Eeepc 1101
From: Zeno Davatz <zdavatz@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
Cc: Zac Medico <zmedico@gentoo.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 7, 2009 at 12:05 AM, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
> Op 06-12-09 17:35, Zeno Davatz schreef:
> :
>>
>> Yes, thanks. That helped another step. I am getting the correct screen
>> resolution after enabling that in the kernel as well. The boot [ok]
>> messages of Gentoo are in a higher resolution now though. That is a
>> good start.
>>
>> But after my X starts I get a black screen with a
>>
>> -
>>
>> in the top left corner. They keyboard also does not work. May be an
>> X.org config problem.
>>
> I've got similar behaviour here if psb is loaded before the X server starts
> (aka there is a framebuffer). If the console is just ascii (no vga=...
> argument on the kernel boot line, and no "modprobe psb"), then X starts
> fine.

When I do X -configure I also get:

X: symbol lookup error: /usr/lib/xorg/modules/drivers/psb_drv.so:
undefined symbol: LoaderRefSymLists

Let me know if you need any other info.

I will now try Eric's version from above.

Best
Zeno
