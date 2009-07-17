Return-Path: <linux-kernel-owner+w=401wt.eu-S933875AbZGQAv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbZGQAv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933570AbZGQAv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:51:26 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:46790 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933427AbZGQAvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PB/ZIMDqh/ioVIBKypSVLnWN5c8iitrv7qWV9G4hr3046hfVEZRWJl8q3/Kolrq9Pe
         yOv/BWn+2plwWAzS1AvVEOO5fZImtFcaNIAO2lxeWOQzn9t+icseP6jjCI5i8Jr7yE8i
         CyfcdkZATItX5KXjjE3yeVPdKrf5JQjcZW0zo=
MIME-Version: 1.0
In-Reply-To: <20090715170351.GB3139@localdomain.by>
References: <20090711191556.GA3845@localdomain.by>
	 <20090711232452.4dc7c1ba@lxorguk.ukuu.org.uk>
	 <20090711235530.GA3231@localdomain.by>
	 <20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk>
	 <20090714162837.GC3145@localdomain.by>
	 <20090715110533.62daf05e@lxorguk.ukuu.org.uk>
	 <20090715102733.GA3055@localdomain.by>
	 <20090715113042.5dbb5822@lxorguk.ukuu.org.uk>
	 <20090715170351.GB3139@localdomain.by>
Date: Fri, 17 Jul 2009 08:51:23 +0800
Message-ID: <a8e1da0907161751t4c9e40f6k8f1ab27dc7c17291@mail.gmail.com>
Subject: Re: possible regression with pty.c commit
From: Dave Young <hidave.darkstar@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 1:03 AM, Sergey
Senozhatsky<sergey.senozhatsky@mail.by> wrote:
> On (07/15/09 11:30), Alan Cox wrote:
>> > On (07/15/09 11:05), Alan Cox wrote:
>> > > > Hello Alan,
>> > > > I'm having another problem which I guess may be caused by pty/tty changes.
>> > > > The problem is that ppp connection constantly hangups under load (downloading)
>> > > > (it works perfectly with 30 kernel).
>> > >
>> > > Have you also got the unthrottle change reverted - without that revert it
>> > > certainly will hang as you describe.
>> > >
>> >
>> I do yes
>>
>
>  d945cb9cce20ac7143c2de8d88b187f62db99bdc "pty: Rework the pty layer to use  the normal buffering logic"
>  and REVERTED a6540f731d506d9e82444cf0020e716613d4c46c "ppp: Fix throttling bugs"
>
> seems to work.

I have same result, the pppoe connection is unstable with the patch.
Are there better solution for this issue?

>
>        Sergey
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
>
> iJwEAQECAAYFAkpeC/cACgkQfKHnntdSXjSGcwQAuDgNU1r+1lgdto4HdBaejLW8
> +DbEVuixCG4PPBM9nlCxI2nK0KydKF/8KRw5iI/GszXlk4WXhlwDcWbAK7BoUPyH
> 3D4uw17BtcYbtn2cmPFeAC4pMVbrDr3CsstBNW6F7K37VYL8bgIfQrEoL9Oi5SUE
> tNV6lyNnuGq/3zSqRA8=
> =ROb6
> -----END PGP SIGNATURE-----
>
>



-- 
Regards
dave
