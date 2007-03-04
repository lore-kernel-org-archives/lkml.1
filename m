Return-Path: <linux-kernel-owner+w=401wt.eu-S1752508AbXCDWt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbXCDWt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 17:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXCDWt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 17:49:27 -0500
Received: from wx-out-0506.google.com ([66.249.82.235]:40826 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbXCDWt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 17:49:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OvNDSIr9yN3CD2LPOt9GW8jm5BkYEKvXfDq33A+CERDsyrFixdBhr9rLt5evA4zBLDbrhuseH9jnyjGqUWsDh5UqyGVX1toKiIdJVhs4qvEOiEF68I9m1rSk75unDY6rhPfHMFQb06kIGZU72JGWwMXEE/13LvVeWDPVQydoHjg=
Message-ID: <ca9528de0703041449x695a4c4bpc133d9afd5524019@mail.gmail.com>
Date: Sun, 4 Mar 2007 19:49:25 -0300
From: "Kirk Kuchov" <kirk.kuchov@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric Dumazet" <dada1@cosmosbay.com>, "Pavel Machek" <pavel@ucw.cz>,
       "Theodore Tso" <tytso@mit.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.64.0703041129550.3300@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070301131118.GA30228@elte.hu>
	 <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>
	 <20070302081047.GA27122@2ka.mipt.ru>
	 <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
	 <20070303100625.GA22557@2ka.mipt.ru>
	 <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com>
	 <20070303203140.GA756@2ka.mipt.ru>
	 <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com>
	 <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com>
	 <Pine.LNX.4.64.0703041129550.3300@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Sun, 4 Mar 2007, Kirk Kuchov wrote:
>
> > On 3/3/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > > <snip>
> > >
> > > Those *other* (tons?!?) interfaces can be created *when* the need comes
> > > (see Linus signalfd [1] example to show how urgent that was). *When*
> > > the need comes, they will work with existing POSIX interfaces, without
> > > requiring your own just-another event interface. Those other interfaces
> > > could also be more easily adopted by other Unix cousins, because of
> > > the fact that they rely on existing POSIX interfaces.
> >
> > Please stop with this crap, this chicken or the egg argument of yours is utter
> > BULLSHIT!
>
> Wow, wow, fella! You _deinitely_ cannot afford rudeness here.

I don't give a shit.

> You started bad, and you end even worse. By listing a some APIs that will
> work only with epoll. As I said already, and as it was listed in the
> thread I posted the link, something like:
>
> int signalfd(...);  // Linus initial interface would be perfectly fine
> int timerfd(...);   // Open ...
> int eventfd(...);   // [1]
>
> Will work *even* with standard POSIX select/poll. 95% or more of the
> software does not have scalability issues, and select/poll are more
> portable and easy to use for simple stuff. On top of that, as I already
> said, they are *confined* interfaces that could be more easily adopted by
> other Unixes (if they are 100-200 lines on Linux, don't expect them to be
> a lot more on other Unixes) [2]. We *already* have the infrastructure
> inside Linux to deliver events (f_op->poll subsystem), how about we use
> that instead of just-another way? [3]

Man you're so full of shit, your eyes are brown. NOBODY cares about
select/poll or that the interfaces are going to be adopted by other
Unixes. This issue has already been solved by then YEARS ago.

What I want (and a ton of other users) is a SIMPLE and generic way to
receive events from _MULTIPLE_multiple sources. I don't care about
kernel-level portability, easiness or whatever, the linux kernel
developers are good at not knowing what their users want.

> As for why common abstractions like file are a good thing, think about why
> having "/dev/null" is cleaner that having a special plug DEVNULL_FD fd
> value to be plugged everywhere,

This is a stupid comparaison. By your logic we should also have /dev/stdin,
/dev/stdout and /dev/stderr.

> or why I can use find/grep/cat/echo/... to
> look/edit at my configuration inside /proc, instead of using a frigging
> registry editor.

Yet another stupid comparaison, /proc is a MESS! Almost as worse as
the registry. Linux now has three pieces of crap for
configuration/information: /proc, sysfs and sysctl. Nobody knows
exactly what should go into each one of those. Crap design at it's
best.

> But here the list could be almost endless.
> And please don't start the, they don't scale or they need heavy file
> binding tossfeast. They scale as well as the interface that will receive
> them (poll, select, epoll). Heavy file binding what? 100 or so bytes for
> the struct file? How many signal/timer fd are you gonna have? Like 100K?
> Really moot argument when opposed to the benefit of being compatible with
> existing POSIX interfaces and being more Unix friendly.

So why the HELL don't we have those yet? Why haven't you designed
epoll with those in mind? Why don't you back your claims with patches?
(I'm not a kernel developer.)

> As for the AIO stuff, if threadlets/syslets will prove effective, you can
> host an epoll_wait over a syslet/threadlet. Or, if the 3 lines of
> userspace code needed to do that, fall inside your definition of "kludge",
> we can even find a way to bridge the two.

I don't care about threadlets in this context, I just want to wait for
EVENTS from MULTIPLE sources WITHOUT mixing signals and other crap.
Your arrogance is amusing, stop pushing narrow-minded beliefs down the
throats of all Linux users. Kqueue, event ports,
WaitForMultipleObjects, epoll with multiple sources. That's what users
want, not yet another syscall/whatever hack.

> Now, how about we focus on the topic of this thread?
>
> [1] This could be an idea. People already uses pipes for this, but pipes
>     has some memory overhead inside the kernel (plus use two fds) that
>     could, if really felt necessary, be avoided.

Yet another hack!! 64kiB of space just to push some user events
around. Great idea!

>
> [2] This is how those kind of interfaces should be designed. Modular,
>     re-usable, file-based interfaces, whose acceptance is not linked into
>     slurping-in a whole new interface with tenths of sub, interface-only,
>     objects. And from this POV, epoll is the friendlier.

Who said I want yet another interface? I just fucking want to receive
events from MULTIPLE sources through epoll. With or without a fd! My
anger and frustration is that we can get past this SIMPLE need!

> [3] Notice the similarity between threadlets/syslets and epoll? They
>     enable pretty darn good scalability, with *existing* infrastructure,
>     and w/out special ad-hoc code to be plugged everywhere. This translate
>     directly in easier to maintain code.

Easier for kernel developers, of cource. <sarcasm> Who cares? Fuck the
users. <sarcasm>

--
Kirk Kuchov
