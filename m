Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbXJWIRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbXJWIRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 04:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXJWIRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 04:17:41 -0400
Received: from xsmtp1.ethz.ch ([82.130.70.13]:42071 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbXJWIRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 04:17:39 -0400
Message-ID: <471DAE1E.1050600@debian.org>
Date: Tue, 23 Oct 2007 10:17:34 +0200
From: "Giacomo A. Catenazzi" <cate@debian.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Crispin Cowan <crispin@crispincowan.com>
CC: Thomas Fricaccia <thomas_fricacci@yahoo.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>,
       LSM ML <linux-security-module@vger.kernel.org>
Subject: Re: LSM conversion to static interface
References: <200710221700.l9MH0klg006152@sapphire.spiritone.com> <471D8C54.4050907@debian.org> <471D9ECB.6060400@crispincowan.com>
In-Reply-To: <471D9ECB.6060400@crispincowan.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Oct 2007 08:17:36.0941 (UTC) FILETIME=[2BABE5D0:01C8154D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Crispin Cowan wrote:
> Giacomo Catenazzi wrote:
>> What do technical and regulatory differences have "driver/LSM module" that
>> is build-in and one that is modular?
>> It seems to me silly to find difference.  A kernel with a new kernel module
>> is a new kernel.
>>   
> *I* understand that, from a security and logic integrity point of view,
> there is not much difference between a rebuilt-from-source kernel, and a
> standard kernel from the distro with a new module loaded.
> 
> However, there is a big difference for other people, depending on their
> circumstances.
> 
>     * Some people live in organizations where the stock kernel is
>       required, even if you are allowed to load modules. That may not
>       make sense to you, but that doesn't change the rule.

[read also the very last commentary: don't take to seriously my
arguments]

ok, but why simplifying life of company with such silly rule?
Are not the same people that required commercial UNIX kernel?
So don't worry about internal company rules.  In one year a lot
of things changes.
Anyway it is a good motivation to delay the conversion, if there
are really so many external LSM modules used in production environment.
(but see next point)

>     * Some people are not comfortable building kernels from source. It
>       doesn't matter how easy *you* think it is, it is a significant
>       barrier to entry for a lot of people. Especially if their day job
>       is systems or security administration, and not kernel hacking.

Configuring a new kernel is not "kernel hacking" and IIRC is considered
in the very first level of LPI.

Anyway where you will find the new module?  It should be very specific
on the actual kernel installed.  I find few differences to distribute
a module or a kernel.  Distributions have/had a lot of kernels
(versions, SMP, processor specific, vserver, xen, readhat, clusteres, 
...), so why not distribute a new kernel?


 > Think of it like device drivers: Linux would be an enterprise
 > failure if you had to re-compile the kernel from source every
 > time you added a new kind of device and device driver.

This is a frequent argument, but I don't believe it ;-)
I see more time this argument that new devices on an enterprise.
The real argument is:
: Think of it like device drivers: Linux would be an enterprise
: failure if you had to *compile* the kernel from source for
: *every machine*.
Which is a good point to have modules.  Is it still a good point
to have LSM modules?  And to obey the "Sarbanes-Oxley"


Don't take me wrong, the above commentaries are not so serious,
and my point was not about modules, but why "Sarbanes-Oxley"
tell us that new modules are simpler then new kernel.

I like kernel without modules, so I want to understand all motivations
why people need modules (and this thread showed me other (non-classical)
reasons).  I know that the modules are necessary in most situation, but
I like to see if some reasons can be solved in other ways, so to
simplify also the life of "build-in" peoples.

ciao
	cate
