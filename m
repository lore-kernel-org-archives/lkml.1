Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286Ab0A1RQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0A1RQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 12:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122Ab0A1RQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 12:16:58 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:48024 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab0A1RQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 12:16:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=g91IHgvCP+Maf5KrOtBaMMieVXGPK+Tma1YQrQNo7BZ70xNG5fu3i/EezTnAxKEMI7
         C3pqkZ2TqV1AzJC/hlK6mCxWznLCRKHUeFImpaJrUrHlnbrcHqNydnmxTykHGuJo6rl1
         X22XjjFWF0d51k3bf5mBra4Mxc8kYdY/1WWPo=
MIME-Version: 1.0
Date: Thu, 28 Jan 2010 09:16:57 -0800
Message-ID: <8db43c661001280916x6f47aae4y7484019e0d3421d7@mail.gmail.com>
Subject: Faster Linux world domination
From: Keith Curtis <keithcu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

“The future is open source everything.”
—Linus Torvalds

Dear LKML;

I have written a book that makes the case for Linux world domination.
The points I wrote should be obvious to you all, but there are some
pages on how to have Linux succeed faster I thought I would summarize
here.

I find it interesting that the idea of Linux on the desktop is treated
either with yawns or derision. I think it depends on whether you see
Linux as a powerful operating system built by a million-man army, or
one filled with bugs and missing the cool stuff like speech
recognition.Given this is such a high volume list, I figured it cannot
decrease the signal to noise ratio very much! ;-) I didn’t see such
emails are disallowed by the LKML FAQ.

I’ve been using Linux since mid-2005, and considering how much better
things everywhere are now compared to then, it surely is an
interesting time to be involved with free software. From no longer
having to compile my Intel wireless driver or hack the xorg.conf, to
the 3-D desktop, to better Flash and WMV support, to the countless
kernel enhancements like OSS -> ALSA and better suspend/resume, things
are moving along nicely. But this is a constant battle as there must
be 10,000 devices, with new ones arriving constantly, that all need to
just work. Being better overall is not sufficient, every barrier needs
to be worked on
(http://www.joelonsoftware.com/articles/fog0000000052.html).

The Linux kernel:

The lack of iPod & iTunes support on Linux is not a bug solved by the
kernel alone, but Step 1 of Linux World Domination is World
Installation. Software incompatibilities will be better solved as soon
as the hardware incompatibilities become better solved. The only
problem you can’t work around is a hardware problem.

If you hit a kernel bug, it is quite possible the rest of the free
software stack cannot be used. That is generally not the case for
other software. Fixing kernel bugs faster will increase the pace of
Linux desktop adoption, as each bug is a potential barrier. If you
assume 50M users running Linux and each bug typically affects .1% of
those users, that is 10s of thousands of people. Currently, the Linux
kernel has 1,700 active bugs (http://tinyurl.com/LinuxBugs). Ubuntu
has 76,371 bugs (https://launchpad.net/ubuntu/+bugs). I think bug
count goals of some kind would be good.

In general, Linux hardware support for the desktop is good, but it
could be better and get better faster. From Intel, to Dell, to IBM and
Lenovo, to all of their suppliers, the ways in which they are all
over-investing in the past at the expense of the future should be
clear; the Linux newswires document them in detail on a daily basis.
Peter Drucker wrote: “Management is doing things right, leadership is
doing the right things.” Free software is better for hardware
companies because it allow for more money to go into their pocket. Are
they waiting for it to hit 10% marketshare first? I was told by an
Intel engineer that his company invests 1% of the resources into Linux
as it does to Windows. It is only because writing Linux drivers is so
much easier that Intel is seen as a quite credible supporter of it.
The few laptops by Dell that even ship with Linux still contain
proprietary drivers, drivers that aren’t in the kernel, and so forth.
I recommend senior IBM employees be forced to watch their own 2003
Linux “Prodigy” video (http://www.youtube.com/watch?v=EwL0G9wK8j4)
over and over like in Clockwork Orange until they promise free,
feature-complete drivers for every piece of hardware in the kernel
tree before the device ships. How hard can it be to get companies to
commit to that minuscule goal?

It is amazing that it all works as well as it does right now given
this, and this is a testament to the general high standard of many
parts of the free software stack, but every hardware company could
double their Linux kernel investment without breaking a sweat. The
interesting thing is that PC vendors that don’t even offer Linux on
their computers have no idea how many of its customers are actually
running it. It might already be at the point that it would make sense
for them to invest more, or simply push their suppliers to invest
more. In fact, it is hard to imagine you can be happy with a device
without having a production Linux driver to test it with.

There are more steps beyond Step 1, but we can work on all of them in parallel.

And to the outside community:
* Garbage collection is necessary but insufficient for reliable code.
We should move away from C/C++ for user-mode code. For new efforts, I
recommend Mono or Python. Moving to fewer languages and runtimes will
increase the amount of code sharing and increase the pace of progress.
There is a large bias against Python in the free software community
because of performance, but it is overblown because it has multiple
workarounds. There is a large bias against Mono that is also
overblown.
* The research community has not adopted free software and shared
codebases sufficiently. I believe there are enough PhDs today working
on computer vision, but there are 200+ different codebases
(http://www.cs.cmu.edu/~cil/v-source.html) plus countless proprietary
ones. I think scientists should move to SciPy.
* I don’t think IBM would have contributed back all of its
enhancements to the kernel if it weren’t also a legal requirement.
This is a good argument for GPL over BSD.
* Free software is better for the free market than proprietary software.
* The idea of Google dominating search and strong AI is scarier than
Microsoft’s dominance with Windows and Office. It might be true that
Microsoft doesn’t get free software, but neither does Google, and
Apple and many others. Hadoop is good evidence of this.
* The split between Ubuntu and Debian is inefficient as you have
separate teams maintaining the same packages, and no unified effort on
the bug list.
* The Linux desktop can revive the idea of rich applications. HTML and
Ajax improve, but the web defines the limits of what you can do, but I
don’t think we want to live in a world of HTML and Javascript.
* OpenOffice is underfunded. You wonder whether Sun ever thought they
could beat Microsoft if they only put 20 developers on it. Web +
OpenOffice + a desktop is the minimum, but the long tail of
applications which demonstrate the power of free software, all need a
coat of polish. Modern tools, more attention to detail, and another
doubling of users will help. But for the big apps like OpenOffice, it
will take paid programmers to work on those important beasts.

There are other topics, but these are the biggest ones. I give away
the PDF http://www.lulu.com/product/download/after-the-software-wars/6276446.
I’ve talked to a number of kernel and other hackers while researching
this and it was enjoyable and interesting. I cite Linus a fair amount
because he is quotable and has the most credibility with the outside
world ;-) Although, Bill Gates has said some nice things about Linux
as well.

If you want to respond off-list, you can comment here
http://keithcu.com/wordpress/?p=272.

Thank you for your time.

Keep at it! Very warm regards,

-Keith
