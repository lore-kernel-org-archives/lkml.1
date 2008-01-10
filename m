Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbYAJXan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbYAJXan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbYAJXaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:30:35 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:53547 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbYAJXae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:30:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sHLeNhGivdv0bHxtVmxH+yj+actSeb82qyhuZMaRXHZdTpOGjFYvjMYJvl9NYPxHcuR2nt8Aa/Vid9tFKLcXO+GY9f2lIaeS0qMP7AXRhP9dJ5Sp68ShdUWk1Ym7KNaTX6WM8OsuoNUkbok1JYNhO0Ye+W7vYlkXRpQBonyZOtI=
Message-ID: <4d8e3fd30801101530j79b35640rea45ea37b41a81c5@mail.gmail.com>
Date: Fri, 11 Jan 2008 00:30:30 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [x86] list of style offenders
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1200006481.29897.48.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199995391.29897.26.camel@imap.mvista.com>
	 <4d8e3fd30801101435l228a0d0ydd0174e4073400e6@mail.gmail.com>
	 <1200006481.29897.48.camel@imap.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 12:08 AM, Daniel Walker <dwalker@mvista.com> wrote:
>
> On Thu, 2008-01-10 at 23:35 +0100, Paolo Ciarrocchi wrote:
> > On Jan 10, 2008 9:03 PM, Daniel Walker <dwalker@mvista.com> wrote:
> > >
> > >
> > > I was playing with checkpatch.pl ;) .. I made a list of style offenders
> > > inside the arch/x86/ sub-directory. I thought it might be helpful to
> > > prioritize any style clean ups that people might want to do for x86 ..
> > > OTOH some of these might show imperfections in checkpatch.pl .. Either
> > > way I thought it was interesting to review ..
> > >
> > > These are sorted by errors, then warnings.. I only included the first
> > > hundred files which includes about the top %30 of the list .. The
> > > kprobes_64.c error rate is a little miss-leading because several errors
> > > are found on a single line ..
> >
> > I just pulled
> > git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86 mm
> >
> > > ./arch/x86/math-emu/fpu_trig.c
> > >                 total: 649 errors, 11 warnings, 1845 lines checked
> >
> > On that tree checkpatch reports:
> > total: 5 errors, 54 warnings, 1643 lines checked
> >
> > > ./arch/x86/kernel/kprobes_64.c
> > >                 total: 528 errors, 9 warnings, 749 lines checked
> >
> > total: 0 errors, 0 warnings, 1 lines checked
>
> I pulled the tree your working with , and it's got mostly the same
> issues .. Are you sure your running the commands properly?
>
> The "lines checked" values that you listed looks wrong .. A few you
> listed as "0 lines checked" , or "1 lines checked" .. Which can't be
> right..
>
> The git logs also show that arch/x86/math-emu/fpu_trig.c hasn't been
> modified since it was pull in on Oct. 11 ..

Top commit in my tree is:
commit 62ba5681e2e2d70794719794eadb441875e6d3b3
Author: From: Jan Beulich <jbeulich@novell.com>
Date:   Wed Jan 9 13:31:14 2008 +0100


paolo@paolo-desktop:~/linux-2.6$ ./scripts/checkpatch.pl --file
./arch/x86/kernel/kprobes_64.c
total: 0 errors, 0 warnings, 1 lines checked

And...paolo@paolo-desktop:~/linux-2.6$ ls -l ./arch/x86/kernel/k*
-rw-r--r-- 1 paolo paolo  2853 2007-11-08 23:00 ./arch/x86/kernel/k8.c
-rw-r--r-- 1 paolo paolo  1207 2008-01-10 23:27 ./arch/x86/kernel/kdebugfs.c
-rw-r--r-- 1 paolo paolo  9828 2008-01-10 23:27 ./arch/x86/kernel/kgdb_32.c
-rw-r--r-- 1 paolo paolo 11936 2008-01-10 23:27 ./arch/x86/kernel/kgdb_64.c
-rw-r--r-- 1 paolo paolo  2223 2008-01-10 23:27 ./arch/x86/kernel/kgdb-jmp_32.S
-rw-r--r-- 1 paolo paolo  1783 2008-01-10 23:27 ./arch/x86/kernel/kgdb-jmp_64.S
-rw-r--r-- 1 paolo paolo     1 2008-01-10 23:27
./arch/x86/kernel/kprobes_64.c <-- What?
-rw-r--r-- 1 paolo paolo 32078 2008-01-10 23:27 ./arch/x86/kernel/kprobes.c

I've pulled the tree as follow:
git branch x86
git checkout x86
git-pull --force
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm

I tried to pull again and I've got:
paolo@paolo-desktop:~/linux-2.6$ git-pull --force
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm
Already up-to-date.

gitweb seems to confirm what I'm seeing:
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=shortlog;h=mm
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=blob_plain;f=arch/x86/kernel/kprobes_64.c;hb=mm
which is an empty file

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
