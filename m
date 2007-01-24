Return-Path: <linux-kernel-owner+w=401wt.eu-S933188AbXAXH7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbXAXH7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 02:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933195AbXAXH7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 02:59:47 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:15917 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188AbXAXH7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 02:59:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hPuG9IaWwFIK72Z0LMgLWI8cdIuu6B3nd3qxzhHsqe/7G1VwNLNbFWRn55mqOMAFrfV0/ght5vXtFVBerjNaIVc4XMVS28CAw3JJRW8jCSAP9sbresKtwxq9mYWNxiA/wi/YFnA7VrBVMAvxWFGtfQp4wUXkfBtXrQuvfXGfOow=
Message-ID: <4ae3c140701232359o50e9c27ahe30d441b8083a7ae@mail.gmail.com>
Date: Wed, 24 Jan 2007 02:59:45 -0500
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: "Oleg Verych" <olecom@flower.upol.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [newbie] Re: Is it possible to directly call do_path_lookup() in kernel?
In-Reply-To: <slrnere41b.e7s.olecom@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ae3c140701231032xd6eca27td46cc1c25e150e25@mail.gmail.com>
	 <4ae3c140701232333j4772794j6e49da2d32c0b26d@mail.gmail.com>
	 <slrnere41b.e7s.olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply.

But more details are appreciated. Actually I checked linkage.h before
I sent last email. Looks like "fastcall" is used to direct the
compiler to put the first 3 parameters into registers instead of
stack. But I just don't understand why that causes "general protection
fault".

I am writing a new file system on Linux platform. So I thought this is
the right email list where I can discuss Linux kernel developing
questions. Is this email list only used to post patches and report
bugs? If so, I will stay away.

-x

On 1/24/07, Oleg Verych <olecom@flower.upol.cz> wrote:
>
> On 2007-01-24, Xin Zhao wrote:
> > Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/485775>
>
> Hallo.
>
> > I just successfully called do_path_lookup() in my kernel module. I
> > just removed the "fastcall" from the declaration of do_path_lookup(),
> > then the problem disappeared. I don't quite understand "fastcall"
> > though.
>
> In linkage.h header near you.
>
> > Can someone explain it?
>
> Please use appropriate mailing list:
>
> Kernelnewbies: Help each other learn about the Linux kernel.
> Archive:       http://mail.nl.linux.org/kernelnewbies/
> FAQ:           http://kernelnewbies.org/faq/
>
> > Thanks,
> > -x
> >
> ____
>
