Return-Path: <linux-kernel-owner+w=401wt.eu-S1759807AbXEIXUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807AbXEIXUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXEIXUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:20:35 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:23447 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbXEIXUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:20:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XSFgarJyLUcsG0MsBe1XkkJ1kR33hMqZg8TVds/PYdWAuuzMgjn9q4uZjQPhtJojmWlc70MvRXDYhCselRf3xz28rMqyQ6NoBfhibAnyzXtpXgUQsQLATsPKIpv19D4PQv79R4UFJEKtagFN22ySM8Jan6ePjRbZYf9XkmE8B58=
Message-ID: <a781481a0705091620t223b0aa7j2c330324dad383be@mail.gmail.com>
Date: Thu, 10 May 2007 04:50:31 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful" document
Cc: "Jonathan Corbet" <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <9a8748490705091547s7a9c6358qabd6b83251f1a449@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25493.1178744744@lwn.net>
	 <9a8748490705091445y65ec74bcpbb9251d9184f481a@mail.gmail.com>
	 <a781481a0705091531x6d4174abmf181371e43bfaffe@mail.gmail.com>
	 <9a8748490705091547s7a9c6358qabd6b83251f1a449@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On 10/05/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> > On 5/10/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > > [snip]
> > > you write: "... that the variable could be changed outside of the
> > > current thread of execution ..."
> > >
> > > I suggest: "... that the variable could be changed outside of the
> > > current thread of execution - a sort of simple atomic variable ..."
> >
> > I'm not so sure here. Why would any C programmer (worth his weight in
> > salt) think that volatile objects are automatically _atomic_? At
>
> I honestly don't really know, but I've encountered that confusion a
> few times. Both from friends who (for some reason) believed that and
> from documents on the web that implied it, aparently it's a common
> confusion - a few examples:
>
>     http://lists.freebsd.org/pipermail/freebsd-perl/2004-June/000124.html
>         "... volatile (atomic) fixes the problem. ..."
>
>     http://blogs.msdn.com/ricom/archive/2006/04/28/586406.aspx
>         "That's the point of the volatile keyword. It makes sure that
> the line "dict = d;" is atomic."
>
>     http://forum.java.sun.com/thread.jspa?threadID=5126877&start=0
>         "A volatile variable is also guaranteed to be read or written
> as an atomic operation ..."  (yes, this link talks about Java, which I
> don't know, but if java volatile means atomic, that might explain why
> some people assume the same for C).

Perl / Microsoft / Java programmers are probably not worth their
weight in salt anyway :-)

I'm not an expert in any of the above platforms either, so don't know
if the semantics of "volatile" in those other languages are different
from that in C -- and this document clearly applies to only the kernel
(and thus C). But if this volatile == atomic disease is indeed common
among _C_ programmers too, then your suggested addition would make
sense.
