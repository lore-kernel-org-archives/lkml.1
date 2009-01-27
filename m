Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZA0WV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZA0WV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZA0WVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:21:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52877 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZA0WVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:21:20 -0500
Date: Tue, 27 Jan 2009 17:20:45 -0500 (EST)
From: Dave Anderson <anderson@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, Bernhard Walle <bwalle@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       crash-utility@redhat.com, Mike Snitzer <snitzer@gmail.com>
Message-ID: <837239885.847621233094845645.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1298337055.846811233094677227.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
Subject: Re: BISECTED: Re: source line numbers with x86_64 modules?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.19.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Eric W. Biederman" <ebiederm@xmission.com> wrote:

> Dave Anderson <anderson@redhat.com> writes:
> 
> > Actually it's not a problem with the vmlinux file, but rather with kernel
> > module object files.  The crash utility has an embedded gdb module which
> > is invoked as "gdb vmlinux", and to get line numbers, the crash utility
> > simply uses the relevant built-in gdb function to get them.  And line
> > numbers work fine with the base kernel code from the vmlinux file.
> >
> > The debuginfo data of kernel modules can be subsequently added to the
> > crash session by doing a gdb "add-symbol-file" command for any or all
> > kernel modules.  But getting correct line number information for kernel
> > modules has been a crap-shoot in the past, depending upon architecture
> > and/or kernel version.  For example, they don't work with 2.6.9-based
> > RHEL4 x86_64 kernel modules, but work fine with 2.6.18-based RHEL5 x86_64
> > kernels.
> >
> > Looking at Mike's suspect kernel patch list, I don't see anything that
> > would have any relationship to the issue.  Perhaps there was a build tool
> > change during the same timeframe? 
> 
> It look like Mike just built a series of kernels and had a problem,
> which should preclude a tool change.
> 
> That said.  Does this feature of crash work in 2.6.29?  If not is
> there enough interest to track this down, and fix it if it is a
> kernel bug?
> 
> If we are going to be using these tools we need them working on the
> latest and greatest kernels, not some weird enterprise branch, for
> fuddy duddies.

Personally I don't know -- I am a fuddy duddy.  

I have tinkered with at least 2.6.28-era vmlinux/vmcore pairs, but never
with any kernel modules thereof.

Dave

