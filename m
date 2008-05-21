Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbYEUXqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbYEUXqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbYEUXqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:46:43 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:9183 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYEUXql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:46:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h1EeZulZsOKj6Cacx0onYREtBWle9OptJMqpkjIo1VQdEGgCEWKeb/MPA90V22Wwseq+EorJFMl5cNAIDi9An6eE3j227EVdDNfKGjUhFJmcAagZV1S1XvVjH0/tDIUon2fd7EkhXFAJJnO1zOY/BewsPXUS8fg0dTCi3UBsoaw=
Message-ID: <9a8748490805211646s5ef93f8ey43ebbc7746fb1a3b@mail.gmail.com>
Date: Thu, 22 May 2008 01:46:28 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard indentation of arguments)
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>, rdunlap@xenotime.net,
       tytso@mit.edu, hch@infradead.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <9a8748490805211337q1e7ceab7i80e4820c46f8171b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490805211306l50b8411ax4462be18c94ca065@mail.gmail.com>
	 <32279.1211401651@vena.lwn.net>
	 <9a8748490805211337q1e7ceab7i80e4820c46f8171b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/21 Jesper Juhl <jesper.juhl@gmail.com>:
> 2008/5/21 Jonathan Corbet <corbet@lwn.net>:
>> Jesper Juhl:
>>
>>> 2008/5/21 Andrew Morton <akpm@linux-foundation.org>:
>>> > Yes, a general GettingStarted document would probably be useful.
>>> > It would hopefully have more what-to-do content than what-not-to-do.
>>>
>>> I'm in the process of trying to write an initial draft of just such a
>>> document right now. I'll post it once I'm a bit more done (gimme an
>>> hour or two).
>>
>> In theory, that's Documentation/HOWTO.  In practice, quite a bit more is
>> needed.
>
> Documentation/HOWTO is indeed a very good place to start.
>
>>I'm actually in the process of writing such a thing as well,
>> with some support from the Linux Foundation.  I'll not have it done in
>> an hour or two, though; a version for review in June is more likely...
>>
> What I'm doing right now is basically reformatting my own notes,
> emails I've written on the subject, pieces of other documents I've
> written etc etc and trying to put them in the shape of a Getting
> Started document.  Perhaps getting that compiled into a reasonable
> document in a few hours is a bit too optimistic, but I'll give it a
> go, post what I have for review and we can take it from there.  :-)
>

Ok, here's a first (very) rough draft of a KernelNewbieGuide document.
It can certainly be expanded a lot and my grammar and spelling is far
from perfect, but hey, it's a first rough draft :)

Comments are very welcome.

-----8<-----[ cut here ]----->8-----


Kernel Newbie Guide - where to start?
=====================================

New kernel hackers can start here.

A commonly asked question, in many different shapes, on the Linux
kernel mailing list is how to get started contributing to the kernel.
This document tries to answer some of the common questions, offer some
advice, list some do's and do-not's and provide a list of other good
resources to visit.


Table of contents
-----
0. Must read documents
1. Documentation
2. How to find things to work on as a beginner?
3. Do I need special hardware or tools to do kernel development?
4. What sort of testing should I do before submitting a change?
5. What version of the kernel should I develop my patch against?
6. My patch was ignored, NACK'ed or flamed, what do I do?


0. Must read documents
---

Every project has some rules about how things are done, what's
acceptable and what's not, some expectations about contributers etc. A
lot of those rules, recommendations and expectations as far as
concerns the Linux kernel are available in a few documents in the
source tree.

A list of the "required reading" documents can be found in
Documentation/HOWTO in the "Documentation" section, so it will not be
repeated here, but please go and find the list of files and do read
them (in addition to this document) - you'll be glad you did.


1. Documentation
---

A commonly asked question is what skills are needed in order to
contribute meaningfully to the kernel.

The answer depends on what areas of the kernel you want to work on. A
good working knowledge of C is a requirement if you want to work with
the code, since the kernel is mostly written in C with a little bit of
asm thrown in. But you don't have to be a programmer in order to
contribute. There are lots of documentation files that need to be kept
up-to-date or need to be written, so there's also lots of work to do
for a competent writer. And the kernel can always use more testers to
make sure the quality is high and bugs are found, reported and fixed.

Another question that gets asked a lot is where to find documentation
on the kernel.

The main repository of documentation is the Documentation/ directory
inside the kernel source, but there are many other sources.

Many people have written books about the Linux kernel, some are pretty
advanced and some are well suited for a new user. Here's a short list
of good books to start reading:
  Linux Kernel Development, second edition
    by Robert Love
  Linux Device Drivers, 3rd Edition
    by Jonathan Corbet, Alessandro Rubini, and Greg Kroah-Hartman
  Understanding the Linux Kernel, Third Edition
    by Daniel Bovet and Marco Cesati

There are also online resources for documentation - here's one of the
better collections:
  The kernel documentation list at KernelNewbies
    http://kernelnewbies.org/Documents


2. How to find things to work on as a beginner
---

Many people new to kernel development have a hard time finding
projects to start out with. The kernel is a large project and it's not
surprising that some people find it hard to work out where to begin.

A good way to start is by trying to fix some bugs.

There are plenty of bugs to go around and fixing bugs is a great way
to learn since you need to understand (and thus learn) the code
surrounding the bug in order to fix it properly, so it usually teaches
a lot.  Submitting small bug fixes is also a great way to get
comfortable with the patch submission process.

Finding bugs to fix is easy. Here are some ways to find useful work to
do:

- Build a bunch of 'randconfig' kernels and log the output from the
build. Building some 10-20 randconfig kernels usually exposes plenty
of warnings and/or errors during the build. Fixing some of those
should keep you busy for a while.

- Grep the kernel source for "FIXME", "XXX" and similar comments. They
often describe areas of the code that has known bugs, could be
optimized, needs review etc. Lots of work to do can be found that way.

- Look through the Kernel Janitors TODO list
(http://kernelnewbies.org/KernelJanitors/Todo) for items of interest,
then try to fix some of the issues on the list.

- Go through the kernel Bugzilla (http://bugzilla.kernel.org/) and see
if you can fix any of the many bugs filed in it. There's a metric
butload of bugs filed in there that need attention.

- Run the 'sparse' tool
(http://www.kernel.org/pub/software/devel/sparse/) against the kernel
source and evaluate the problems it finds. Try and fix any real
problems it reports.

- Sign up with Coverity (http://www.coverity.com/) to get access to
the results of their regular runs of Coverity Prevent against the
kernel source. Their static analysis of the kernel source finds many
bugs that need fixing. There is lots of good work there that needs
doing.

Naturally there's also other work that can be done, like writing a
driver for some, currently unsupported, hardware etc, but its probably
best to get your feet wet with some bug fixing first.

Try to stay away from doing pointless work, like just fixing up the
coding style in a file, reformatting comments etc - it's not worth the
effort and your patch is likely to be rejected. Fixing up incorrect
comments to be correct, fixing up references to removed or renamed
functions/arguments etc is, however, useful and worth doing.


3. Do I need special hardware or tools to do kernel development?
---

In most cases you don't need any special hardware to hack the
kernel. Unless you are developing a driver, in which case you need
access to the hardware in question, naturally - or if you want to hack
on architecture specific code it's probably a very good idea to have
access to at least one machine of the type.

As far as tools go, all you really need are the tools compile the
kernel (gcc, make etc) and a text editor to edit the source - vi,
emacs, joe, almost anything will do fine.

However, while you can do kernel development just fine on your regular
desktop/laptop PC, there are some things about having a second PC
available that can sometimes make your life easier. When the kernel
crashes or just misbehaves slightly (for example if your patch has a
bug) it may leave your system in a state where it's difficult to get
access to log output or other debug information. In those cases,
having a second PC connected to the one running the faulty kernel via
ethernet or serial cable and having a netconsole or serial console
setup to capture kernel messages remotely can be of great value.

Its also important to remember that a faulty kernel might do anything
to your system, so keeping backups of important data if you don't have
a dedicated kernel development machine is stongly recommended - if
your change (or just the experimental kernel of the day you decided to
test) causes data loss and you don't have backups, that's entirely
your responsability (and headache).


4. What sort of testing should I do before submitting a change?
---

Testing patches before submitting them is important. Very
important. You can't test a patch too much.

At a bare minimum you should test that your patch compiles cleanly
without errors or warnings from the compiler and you should at least
try booting a kernel with your patch applied to see that it doesn't
blow up instantly at runtime.

For some patches it can also be sensible to write a test program to
test kernel behaviour with and without your patch. This is especially
true for patches that touch user visible interfaces, like modify
system call code, change files in ProcFS or SysFS or similar. If there
is a way to write a program that tests the impact of your patch, then
doing so is a good idea and submitting your test program along with
your patch (so other people can test as well and verify the patch) is
a great thing to do.

When you submit your change, listing in the submission email exactely
what testing you have done is important. The more testing a patch has
seen the more likely it will be accepted.


5. What version of the kernel should I develop my patch against?
---

There are many versions of the kernel. Development is happening at a
very rapid pace and there are many people maintaining development
kernel trees for various purposes. Knowing which one to develop
against can be difficult to determine when you are just starting out.

In some cases it's easy; if you are working on a very specific area
like the real-time properties of the kernel, then the experimental -tr
tree is probably what you want to develop against. In most cases
however, you probably want to develop your changes against a
reasonably up-to-date snapshot of the mainline kernel (Linus' git
tree). Or at least, the latest release-candidate (-rc) development
kernel available. If for some reason you can't use a recent snapshot
or the most recent -rc kernel, then the most recent stable kernel
version is your best bet.

Developing against anything older than the latest stable kernel is
likely to be a waste of effort due to the rapid pace of
development. Once you finish your patch against a several months (or
even weeks) old kernel, your patch runs a great risk of being obsolete
or impossible to apply (this greatly depends on the area you work on
ofcours cince some areas change more rapidly than others, but do try
to submit patches against recent development kernels).


6. My patch was ignored, NACK'ed or flamed, what do I do?
---

When you submit a patch, naturally you hope that the patch gets
applied either directly to mainline or to a subsystem tree or testing
tree that will eventually carry it to mainline. That, however, doesn't
always happen. Sometimes your patch doesn't get any feedback at all or
someone comments on it with a NACK (meaning they disagree with the
patch and vote that it does not get merged) or you get a bunch of
(more or less serious) negative feedback on the patch.

The thing to do when your patch gets no feedback at all and seems to
have been ignored by everyone is to, first of all, let some time
pass. Not everyone read email daily, so you may get the feedback in a
few days.

If some days pass and there's still no response it's time to resubmit
the patch. First of all you should check that the patch still applies
to the latest development kernel and re-spin it against a recent
kernel if it doesn't. The next thing to do is consider whether your
subject was good enough; did it clearly state the nature of the patch?
You also need to consider whether you submitted the patch to the
proper people. You should spend a bit of time trying to work out who's
responsible for the code your patch modifies - most areas of the
kernel have maintainers, listed in the MAINTAINERS file - look up the
maintainer for the area you are modifying and make sure that person
(or persons) is on the To: or Cc: list of your email. Adding the
author of the original code (sometimes, but not always, the same as
the maintainer) to Cc: is usually also a good idea. Authors are often
listed at the top of the source files, so look there for a name. You
should also generally (unless there's a very specific reason not to)
add the linux kernel mailing list and any subsystem specific lists to
Cc. Now re-submit your patch with an improved subject and recipient
list and see if you get a reply. Sometimes you may have to resend your
patch multiple times (putting a week between resubmissions is a good
rule of thumb) before someone picks it up - don't give up.

If your patch did not get applied and you recieved an ACK or some
criticism about your patch, then your job is easy. If there's a very
explicit rejection of the patch by the maintainer of the code with a
good reason, then don't bother sending it again, it probably will
never be applied. If the patch received improvement suggestions or
other review comments, then you should create a new version of your
patch that adresses the feedback you get and then re-submit (it's
usually a good idea to list what stuff you've adressed when
re-submitting).


Hopefully the above has helped you get started with the kernel.
Happy hacking. We look forward to your first patch.


=====
Written by: Jesper Juhl, May 2008.


-----8<-----[ cut here ]----->8-----

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
