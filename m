Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYCNBCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYCNBCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYCNBCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:02:05 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:37576 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbYCNBCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:02:04 -0400
Date: Thu, 13 Mar 2008 21:02:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: whose job is it to include various header files?
In-Reply-To: <9a8748490803131653n7f1c2bd0m12e30d82bf936d03@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0803132100270.21017@localhost.localdomain>
References: <alpine.LFD.1.00.0803131802020.20317@localhost.localdomain> <9a8748490803131653n7f1c2bd0m12e30d82bf936d03@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, Jesper Juhl wrote:

> On 13/03/2008, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> >
> >   more a philosophy question than anything but, while poking around
> >  the percpu stuff today, i noticed in the header file linux/percpu.h
> >  the opening snippet:
> >
> >   #include <linux/preempt.h>
> >   #include <linux/slab.h> /* For kmalloc() */
> >   #include <linux/smp.h>
> >   #include <linux/string.h> /* For memset() */
> >   #include <linux/cpumask.h>
> >   ...

> I agree with you completely. A file should explicitly include
> headers for the stuff it uses and not rely on implicit includes done
> elsewhere. Cleaning that up is going to touch a lot of files though
> for no real short term gain (there is a long term gain of
> maintainability though), so it's going to be a loveless job :(

i wasn't about to run off and start changing stuff, i was just curious
about the general philosophy.  i *might* see the value of a patch if
it's a cleanup that affects a restricted set of files that are
logically related and can be done with a single patch.  beyond that,
no.

the only reason the above example caught my eye is the insistence in
the comments as to why those includes were there, when there were no
invocations of those routines anywhere in the file.  i always find
that curious.

rday
--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
