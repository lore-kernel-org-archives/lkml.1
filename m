Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYADW1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYADW1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYADW0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:26:50 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:53075 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbYADW0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:26:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=d1odsgP2EhuFv9kM1bTCVn1EcFDSlwjFXvVUkgMMsOUAz4aDmcGxCd4rj7knHt315b8R3/NT4LpUcnWkx7Y7k/x/gDmSuwXL3G3MxJ03SMqhu5mFqVH+7yRXB5pB9Y+9mY2FfuF8TOcCzQNI+Bw0io2ugxyMwPkY/4KcsPBMAXI=
Message-ID: <8499950a0801041426r43df1157n6020877bb8e175da@mail.gmail.com>
Date: Fri, 4 Jan 2008 23:26:42 +0100
From: "Oleg Verych" <olecom@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: stuff (Re: Kbuild update)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 4, 2008 9:09 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jan 4 2008 20:43, Sam Ravnborg wrote:
> >On Thu, Jan 03, 2008 at 11:33:44PM +0100, Jan Engelhardt wrote:
> >>
> >> On Jan 3 2008 22:32, Sam Ravnborg wrote:
> >> >
> >> >On top of this I have my personal todo items such as:
> >> >- modern ncurses interface for menuconfig (ala tig, htop and others)
> >>
> >> Sorry.. your comparison {menuconfig, htop} raises an "incompatible
> >> pointer passed" on my side. Please explain :)
> >
> >htop is a nice ncurses based interface to top.
> >
> >Try "F2" and see a nice layout for a menu structure remotely
> >similar to menuconfig.
>
> I cannot really think how htop F2 would even be CLOSE to menuconfig.
> Just that we are talking about the same thing:
>         http://jengelh.hopto.org/GFX0/htopf2.png
> hell no, menuconfig looks much nicer than that.
>
> >I could mention a few more - this was more to say that there
> >exist much beter looking ncurses based tools than menuconfig.
>
> hm, I can only think of mc right now.

ncurses is the tty(terminal) independent interface to generic
character-based displaying devices, it has nothing to do with
the ``look'', only stupid legacy and dead stuff.

Borland Turbo Vision has a look, but it was closely
tied to OO model and features of the library. Comparing
Midnight Commander (c) 2007 to Dos Navigator (c) 1997,
i pretty much about to say, that former blow-sucks, even
latter had DOS as an ``OS''.

Going back to ttys. I was very deeply impressed, after i
started to look back in history.

I was searching for shell history shortly after having all
kbuild ideas and historical research done.

In parallel i was thinking about user interface and IDE (even
if it will be not so luzer-friendly, eye-candy as drag-graphical
ones). UI on character-based devices. This is where i hit
another shit in terms of tty layering, tty controlling, user/kernel
space tty drivers and TERM=linux codebase quality/featurity
and userbase(wtf ncurses?).

After in-kernel printk coloring stuff, i was completely upset.

I've found a link about origins of the Almquist Shell (ash).
Kenneth Almquist had alternative not only for proprietary
shell implementations. He also implemented atty -- userlevel
tty, which is, in my opinion, has much bigger potential. All i
need from kernel now is a fast region (with chars/attributes)
filling routine, much like Turbo Vision has.

But nearly 20 years after, BSD, Free Software and Open Source
hypes led userspace to almost nowhere (IMHO). Yes Linus and
Linux are cool, but what else? udev?
Thank you very much!

People, where is you imagination? I know it's hard to have a few
time for Linux, but this doesn't mean one must stop thinking and
asking questions.

Now, what can i do to mc-minded people, having (colored) printk
in non-debugging kernels, managed via udev?

Reach and flexible build system with UI as comfortable as a brush
and easel for painter? No, i'd better do something else...

ftp://flower.upol.cz/dts/Ash0000/

i did sorted out (a)sh stuff; kbuild ideas, which are much more
complicated and require at least those improvements to the shell,
i did send some time ago with almost no positive reaction.
Now i pretty much sure, why there was such reaction.

BTW, ash had built-in `test` && `expr`, appeared from nothing
today's odd job, where bash GPL routine is copied instead of Linux's
euidaccess() is a... A little surprise!

http://sourceware.org/ml/libc-alpha/2007-01/msg00099.html
`--http://sourceware.org/ml/libc-alpha/2007-01/msg00105.html

With the flexible build system, which can tune everything easily, such
crap form the software whore, couldn't exist. Does shell know, about new
size of the quanta of the pipe in Linux? One must write m4 autoconf crap?..

200X Monty Python: Crap. "Crap, crap crap. Crap? Crap crap!"
http://www.youtube.com/watch?v=wZ7YedEopp4
Or...
http://www.adultswim.com/video/?episodeID=8a25c39214b602990114b8a43a37012b

> -
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Yes, fsck! I AM SUBSCRIBED! AND I KNOW WHAT TO DO IF I WILL
CHANGE MY MIND!
PLEASE CC ME, I DON'T FOLLOW LKML!!!!!!
Oh, crap.
-o--=O`C
 #oo'L O
<___=E M
