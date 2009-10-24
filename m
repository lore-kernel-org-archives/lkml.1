Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbZJXWvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbZJXWvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 18:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbZJXWvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 18:51:36 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:51439 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbZJXWvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 18:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=rt/xFljfXf7yOCRIN2+WG6yhQavQRUO028K0cRacv9B7wR/olxYOkVA5VZ9ckS3lp6
         AEPDuc5hwUyuT4+e83T37VGk6LXInKBo+A5FcCF2bhXePev1H8OoV2R8qFH19h5BSPYr
         vorTxxBhTGbFnq4Sh1bRy2S0U1fvHyS4+QqxA=
MIME-Version: 1.0
In-Reply-To: <20091024115933.GA6999@console-pimps.org>
References: <1253888440-14111-1-git-send-email-matt@console-pimps.org> 
	<8bd0f97a0909251000y3316891dh4d09744ed98139e8@mail.gmail.com> 
	<20090928080729.GB6793@console-pimps.org> <8bd0f97a0909281339p1abe6ff0h1ef4e05887a2413d@mail.gmail.com> 
	<20091024115933.GA6999@console-pimps.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 24 Oct 2009 18:51:20 -0400
Message-ID: <8bd0f97a0910241551x7216c2b4sb8518e1a12ff346e@mail.gmail.com>
Subject: Re: [PATCH] lib/checksum.c: Fix another endianess bug
To: Matt Fleming <matt@console-pimps.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24, 2009 at 07:59, Matt Fleming wrote:
> On Mon, Sep 28, 2009 at 04:39:38PM -0400, Mike Frysinger wrote:
>> On Mon, Sep 28, 2009 at 04:07, Matt Fleming wrote:
>> > On Fri, Sep 25, 2009 at 01:00:25PM -0400, Mike Frysinger wrote:
>> >> On Fri, Sep 25, 2009 at 10:20, Matt Fleming wrote:
>> >> > From: Matt Fleming <matthew.fleming@imgtec.com>
>> >> >
>> >> > This fix allows the generic checksum code to work on my little endian
>> >> > system. The previous fix was not enough, as "buff" is a big-endian
>> >> > value. Without this patch I see malformed TCP packets.
>> >>
>> >> can you try this one ?
>> >> http://lkml.org/lkml/2009/6/23/597
>> >
>> > Yep, that one works fine also. Thanks, Mike. Who's going to pick this
>> > up? I'm guessing this commit is also applicable for stable? Though, I
>> > don't know if there are any little-endian users of this code in stable.
>>
>> i'm converting Blackfin to it now that the LE issues should be fixed,
>> but i'm going to hold off on pushing the change until it can be tested
>>
>> as for picking up the fix, let's ask Andrew ...
>
> Ping?
>
> Andrew, Arnd, could one of you pick this up?

we've been using the generic checksum code with this fix on Blackfin
boards for the last month and havent noticed any regressions so far
...
-mike
