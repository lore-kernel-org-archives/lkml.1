Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXDXBMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXDXBMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 21:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbXDXBMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 21:12:21 -0400
Received: from web88104.mail.re2.yahoo.com ([206.190.37.205]:36833 "HELO
	web88104.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754130AbXDXBMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 21:12:20 -0400
X-YMail-OSG: 7wmeCMsVM1mPMSxGjOJtALK8KW2cqvZlUHVD9XRfKw1b1O9U_aCuBMig2z0Y_8gGn0R3DrfDLdoQ3kh_UyDDe6gz5fgi6QvvJC8kJ2B_rdPfnqZqVUNNBA--
X-Mailer: YahooMailRC/478 YahooMailWebService/0.7.41.10
Date: Mon, 23 Apr 2007 18:12:19 -0700 (PDT)
From: Matt Ranon <mranon@javadevices.com>
Subject: Re: [ANNOUNCE][PATCH] Kcli - Kernel command line interface.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux maillist <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <617125.34935.qm@web88104.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> (text reformatted to less than 80 cols.  Please, we'll get along a lot
> better if you don't send 1000-column emails)

Sorry. I am afraid we are from a different background, and so very
poorly versed in these things. My email client does not seem
to have an option to tell it to format in 80 cols. So, hopefully,
using CR, I am achieving the same effect. Let me know if
it doesn't work, and I will have to switch to a different email
client for conversing with the lkml.


> The obvious question is: what's _wrong_ with doing all this in some
> cut-down userspace environment like busybox?  Why is this stuff better?
> 
> Obviously some embedded developers have considered that option and
> have rejected it.  But we do need to be told, at length, why that
> decision was made.

There is nothing _wrong_ with doing it all in a cut-down userspace. It
is a matter of personal preference, culture, and the application. That
is what makes Linux so great, it is all about choice.

We are developing devices that don't have a user space, and we don't
see the point in including one just for debug purposes. We will not be 
offended if Kcli is not included into the kernel mainline, nor if Kcli compels
people to call us stupid (as it already has) just because we are different 
and some people don't understand us. We are firm believers that the 
world, including the Linux kernel world,  would be a nasty place if there 
was only _one_ way to do any given task. Additionally, we  are almost 
certain that there will be others who think like we do, so we are reaching 
out to them. We also feel compelled to give _something_ back to the 
community that has given so much to us, and, for now, this is all we have.

However, our reasons for Kcli are:
1) Our devices ship with no user space, and we want the development
environment to be as close as possible to the final product.
2) Getting debug information with user space calls require context 
switches and data copies, which changes the real time profile and can mask
bugs. 
3) To use user space, we would need cross compiled libc's, special
builds of gcc, root file systems, flash storage to store it all, and all 
sorts of things which make life a lot more complicated than it needs 
to be for us. We are quite capable of producing all these things, but,
we just don't see the point in it. Our way, we just have a gcc capable 
of cross compiling the kernel and it is so simple.
4) For us, it is the opposite argument. We would need to be convinced
that having user space is worth all the overhead. Not just CPU
overhead, but all the overheads.
5) We like it in the kernel, we find it to be warm and fuzzy. Whereas,
user space is a cold, dark, and rainy place, and we just don't want to
go there. :)

We do not claim to have come up with a _better_ way. We have just
created something that we feel would be useful to others.

MRanon.
