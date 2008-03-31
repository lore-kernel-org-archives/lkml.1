Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbYCaPwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbYCaPwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 11:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYCaPwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 11:52:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:28613 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYCaPwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 11:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p2EAIVS0HxTm1FvjJCtn2J+8hQliAcwKcPAuJ7eNg9DnyXJ69Gii6PCDTxyA6LWyK7Ubr+notjbXvpmDUBUgBceDjazKdPCEElxGnJZPj80ARXYOZNUBOO5xcZ14cEGLYYKw+hy1VTltE2PB3UiOHhOBA/yo1zjRZdp+RdXLk9Y=
Message-ID: <804dabb00803310852k507bd6b8ka2eac9a0f070d4ab@mail.gmail.com>
Date: Mon, 31 Mar 2008 23:52:30 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: RFC: Writing Solaris Device Drivers in Java
In-Reply-To: <804dabb00803310818u36b29ea3hf10ec0e44fdf7d8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F0491F.4050804@gmail.com>
	 <E1JgAEe-0006hb-00@calista.eckenfels.net>
	 <804dabb00803310818u36b29ea3hf10ec0e44fdf7d8c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 11:18 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> Thank you for the comments.
>
>
>  >
>  >  I think the device driver reuse between the various C-kernels is pretty big.
>  >  For efficiency and since the low level stuff is a major part of device
>  >  drivers, I cant see a Java solution. I guess we would see drivers in Forth before :)
>
>  not sure about forth, but fortran is claimed to be faster than C,
>  based on ease of optimization reason:
>
>  http://www.idiom.com/~zilla/Computer/javaCbenchmark.html
>
>  For a surprising benchmark dated Oct2007, this guy started off without
>  knowing who will win:
>
>  http://www.stefankrause.net/wp/?p=4
>  http://www.stefankrause.net/wp/?p=6
>
>  Looking at all those number, unbelivebly Java performed better than
>  gcc in several ways. To quote the author:
>
>  "# Saying that C is generally several times faster than java is -
>  according to those benchmarks - simply wrong."
>
>  but he also cautioned:
>
>  "# Saying that Java is faster than C can also be pretty wrong,
>  especially if you have to stick with one JVM."
>
>  http://www.freewebs.com/godaves/javabench_revisited/
>  http://kano.net/javabench/
>
>  well, performance of speed is one thing, but other stuff like (for
>  desktop computing) ease of support, enhancement, and ease of use need
>  to be considered as well.   That's why .Net, with its huge overheads,
>  still has a huge followers, even though its predecessor is much more
>  efficient and faster, and delivering the same level of GUI programming
>  feature.
>
>  For embedded and server-based computing performance will still be
>  king.    But won't you be enticed to a new world of programming where
>  one or two liners can replaced 10 lines in C? With the complexity in
>  locking and irq handling all taken care of underneath you?   Ie,
>  automatic synchronization done by some other components in the kernel,
>  thus reducing the lines of codes?
>
>  Well.....the future is uncertain....i cannot predict it :-).   Happy
>  April Fool's Day (I like that joke!!!! LOL...)

Just would like to comment further:   analogous to the trend that with
the huge increase in storage space availability, size of storage
required is of minimal concerns, in comparison with other more serious
bottlenecks,  the future CPU may have so much spare execution cycles,
that emulation (like what Java or AMD Pacifica or Intel VMX is doing)
is a much needed feature instead, as it provide other feature like
security assurance etc, without affecting interactivity on the users,
or perhaps being overshadowed by other bottleneck (like network I/O,
or harddisk I/O etc).

Thanks.



-- 
Regards,
Peter Teoh
