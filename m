Return-Path: <linux-kernel-owner+w=401wt.eu-S965449AbXFFWmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965449AbXFFWmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964936AbXFFWlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:41:15 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:19194 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964981AbXFFWlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:41:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WYStCk+d+QkRD5alsMeqXclLfdcLr3RlabuUm5cQNUn7lmQ9Nemdd58fpRAvldlaMcZ6QUbOIUg9uxqQUoRSYG6tHfNy7jKyrj8L0dd1Ct3V6kFHhjhWgAE4FX9xKclKV+hmSGjaMkYVTBudt8F63vNYXPoNw+xi2d3prudwe80=
Message-ID: <f4527be0706061541ifd49a8fg60442532d72f1d06@mail.gmail.com>
Date: Wed, 6 Jun 2007 23:41:11 +0100
From: "Andrew Lyon" <andrew.lyon@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Re: 4Gb ram not showing up
In-Reply-To: <46673135.30105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.58.0706061356310.2657@be1.lrz>
	 <20070606143723.GF10008@csclub.uwaterloo.ca>
	 <46673135.30105@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Lennart Sorensen wrote:
> >
> > Seems like an improvement to me.  To fully explain how it could be 3 or
> > 3.5 or 3.25 or who knows how many GB you can actually use without PAE
> > would probably require writing a small novel.  Certainly talking about
> > address space instead of amounts of physical memory is more correct.
> >
>
> On some machines it's even just 2 GB.
>
>         -hpa
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Could this also cause a system to be unstable? my abit athlon64 at
work will not run x64 with more than 1gb ram, and i have a colo server
with supermicro & 2 x dual core xeons that will not run with more than
2gb.

Both systems have long uptimes but if i add ram they crash within
minutes of booting.

Tried several kernels up to 2.6.21 and gave up, I can send dmesg
output but the crashes are completely random.

andy
