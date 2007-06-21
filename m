Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbXFUW3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbXFUW3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 18:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbXFUW3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 18:29:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:55607 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbXFUW3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 18:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HUk6EkGu+gPF8mN1X1ho2u9gmYjnVYvfDSeZFp7LsbL49luckffE78MvO0pmwmbf3wsO0I6OgxpCnBhrslVHm3RWE7jpc9mzqyMYO+ck80xl4OgXg2oVmgivdwSt954ZPJSYs6T5xWgkhyr4g/EQHe7kuMTrDGBatUTt+VsRODI=
Message-ID: <9a8748490706211529yca0588dgd1f7e0b86f7e4a62@mail.gmail.com>
Date: Fri, 22 Jun 2007 00:29:20 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "=?ISO-8859-1?Q?Zolt=E1n_HUBERT?=" <zoltan.hubert@zzaero.com>
Subject: Re: Please release a stable kernel Linux 3.0
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200706212349.54983.zoltan.hubert@zzaero.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200706212349.54983.zoltan.hubert@zzaero.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/07, Zoltán HUBERT <zoltan.hubert@zzaero.com> wrote:
[snip]
> All people who might read this know that traditionally
> stable releases are even numbered and development branches
> are odd numbered. This changed during late develoment of
> 2.6, according to my analysis because of the "invention" of
> GIT which was itself necessary because of BitKeeper (insert
> ooooooooold flame-wars here) and which allowed very dynamic
> develoment.

Git itself, nor bitkeeper was not the main reason behind the desition
to maintain 2.6.x as the stable kernel going forward.

> While this has been effective, alternative
> voices (Mr Morton complaining that more bugs were added
> than repaired, semi-stable semi-supported 2.6.x.y branches
> where invented...) come more and more into the front.

I myself have argued that we should be focusing more on stability and
regression fixing, but I'm not so sure that a 2.6.7 devel branch would
solve this. In general the 2.6.x.y -stable kernels seem to be doing
the job pretty good.

>The
> upcoming GPL v3 versus v2 debate will make things worse,

How is the GPLv2 vs GPLv3 debate relevant to kernel stability, ABI
stability or anything else of the sort?

> and we all know this. The un-ending stable ABI argument
> goes into this same direction.

What I think you are wishing for is a stable API - which is not going
to happen; please read Documentation/stable_api_nonsense.txt
(http://lxr.linux.no/source/Documentation/stable_api_nonsense.txt).
A stable ABI we already have.

[snip]
> You might think it's easy for me to simply "use" Linux and
> complain while you're doing the hard stuff. As it happens,
> the current development/stable model makes our life as
> "users" more and more difficult.

In what way?

Most users should be using distribution kernels anyway, not vanilla
kernel.org kernels. Those distribution kernels should provide you with
all the stability you require.

>I'm using Linux since 1997
> on a Mac thanks to LinuxPPC-1997, and I'm a hard pusher of
> Linux whenever possible, sometimes against the common
> sense, for example when I favor using National Instrument
> cards with Linux drivers and custom written TCP/IP server
> against easy LabView on Windows. While some of you dislike
> closed source drivers, the choices "we users" face are:
> - closed source drivers with closed source OS
> - closed source drivers with open source OS
> Please consider that we are living in a REAL world, and not
> Disney-Land.
>

As far as I am aware, both nVidia and ATI have closed drivers
available for you to use if you please. And they should work just fine
with most distribution kernels as well as vanilla.


> So I've demonstrated that from a "users" perspective a new
> stable Linux would be of advantage. I'll now list what I
> suggest for this new stable branch:
>
I don't think you have demonstrated that.
How specifically is the current development model hurting you?
What exactely would we gain by switching back to the old
stable/unstable branch model?

[snip]
> Why on earth
> call "kernel object" things that are "kernel modules" ? And
> that every person calls "modules" and not "objects" ? I
> know I know, in UNIX dynamic libraries are .so "shared
> objects", so what ? A "module" is a "module" and NOT an
> "object", call a cat a cat.
>
It sure is an object, it's even called object code. I think the name
suits just fine. In any case, it's just a name.

> Third, while a stable ABI in a dynamically developed kernel
> is a difficult/impossible/unwanted feature,

A stable ABI is very much a wanted feature and one that a lot of work
goes into maintaining.
Note; ABI != API.

> it should be
> possible to implement in a stable branch. This could even
> be a distinction between "stable" and "development"
> branches. And it would certainly help vendors of
> closed-source drivers.
>
If they want to keep their drivers closed they get to do all the hard
work of tracking kernel API changes. Their choice, their problem. I
don't think you'll find very many people on this list who gives a damn
about the troubles of closed source driver developers.

[snip]


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
