Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbXGHKs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbXGHKs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 06:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbXGHKsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 06:48:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:55471 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751085AbXGHKst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 06:48:49 -0400
Cc: drepper@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 08 Jul 2007 12:48:48 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <Pine.LNX.4.64.0707081159530.1536@fbirervta.pbzchgretzou.qr>
Message-ID: <20070708104848.238020@gmx.net>
MIME-Version: 1.0
References: <468FBEB7.1000308@gmx.net>
 <Pine.LNX.4.64.0707072057030.1536@fbirervta.pbzchgretzou.qr>
 <20070708073042.238020@gmx.net>
 <Pine.LNX.4.64.0707081159530.1536@fbirervta.pbzchgretzou.qr>
Subject: Re: utimensat (man-pages-2.61 is released)
To: Jan Engelhardt <jengelh@computergmbh.de>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX192cetweqt2ndu1c8b5lYMP7ir76d/RavkZ31QW4T
 H+7qisR96YJflZvvK41GIKIv4oJyb2qASExg== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: dbD5KYhkMydhbfHKEWtlL6JjaGRhZhoV
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Jul 8 2007 09:30, Michael Kerrisk wrote:
> >> On Jul 7 2007 18:26, Michael Kerrisk wrote:
> >> >
> >> >I recently released man-pages-2.61.
> >> 
> >> utimensat() was introduced in Linux 2.6.22-rc1.
> >
> >Yes, I am aware.
> >
> >> I am kindly hinting that it does not yet have a manpage yet :)
> >
> >Such a hint is a good idea.  But strangely, you send it to me,
> >rather than the author of the system call.  Why is that?
> 
> Related manpages (futimesat(2)) does not list an author.
> So I were to guess who wrote it: you, or Ulrich, or a contributor.

An author of which -- the man page itself, or the system call?
Looking at the source of almost any page in man-pages certainly
shows the author of the page.  In the case of the futimesat(2)
man page: yes, I was the author.

So yes, I sometimes write pages for system calls that were 
written by others.  But this suffers serious limitations:

* Many people are changing the kernel-userland API; leaving me
  to write the documentation does not scale well.  (To begin
  with there is the problem: how can I even tell what has
  changed in a new release?  But here I must thank Andrew,
  who helps a bit by forwarding me things he notices.)

* I am fallible: I sometimes make mistakes of understanding
  when interpreting other people's code.

* Even when I do not make mistakes, when I write a man page by
  reading someone else's code, all I am doing is interpreting.
  The implementation may not match the (code) author's
  intention (aka a bug).  I may just be accurately documented
  buggy behaviour, or accurately describing design mistakes.
  (Yes, sometimes I'm smart enough to recognize the bugs and
  call them, but that is far from guaranteed.)

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

