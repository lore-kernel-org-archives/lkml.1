Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbXJYTKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbXJYTKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbXJYTJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:09:59 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:37919 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbXJYTJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:09:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mc3FflqI2gq1oZqQtVhJMByZa3Z/er7nmsK/f0kKzd1Ew1M1GGSYOHmu3wHcqc0oe63qoADjK+Os+TfidIkxzjzQ5KUT1P/Fe5d45IF2qnVuARoq8Q9PRlgAMxWSfJqc/lyOhfbIsekCY8cTPELuWp+pXT9cf6jWDjWPEdrreP8=
Message-ID: <fc94aae90710251209n74e2cffbj2e3cdd321f36da0d@mail.gmail.com>
Date: Thu, 25 Oct 2007 20:09:56 +0100
From: "Michael Lothian" <mike@fireburn.co.uk>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: Possibility of adding -march=native to x86
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071025185022.GP30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net>
	 <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com>
	 <20071025185022.GP30533@stusta.de>
X-Google-Sender-Auth: 78d20495a0d8acc4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Actually I changed the Makefile.cpu and changed the -march to native
which did slightly change the size of the kernel (slightly larger I
think)

So what else does that option change?

Mike

On 25/10/2007, Adrian Bunk <bunk@kernel.org> wrote:
> On Thu, Oct 25, 2007 at 07:33:35PM +0100, Michael Lothian wrote:
> > Hi
> >
> > I was wondering if it was possible to add -march=native support to the
> > processor options of the new x86 architecture if gcc 4.2 or greater is being
> > used.
> >
> > I'm not suggesting this should be a default at all, merely an extra option
> > similar to selecting P4, Athlon or even -Os.
> >
> > I've manually tried this flag at home with no ill effects.
>
> Selecting your CPU in the kernel configuration has more effects than
> just setting the gcc flag, so it wouldn't gain you anything since you
> anyway have to choose the correct CPU.
>
> > Mike
>
> cu
> Adrian
>
> --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
