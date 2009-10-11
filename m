Return-Path: <linux-kernel-owner+w=401wt.eu-S1759933AbZJKCJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933AbZJKCJa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 22:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759032AbZJKCJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 22:09:29 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:63436 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbZJKCJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 22:09:29 -0400
MIME-Version: 1.0
In-Reply-To: <92be2ef30910101208p1b2eb493wdfa46d363ca96f99@mail.gmail.com>
References: <1255165747.6385.117.camel@doodleydee> <alpine.LFD.2.00.0910101931080.9428@localhost.localdomain> 
	<92be2ef30910101208p1b2eb493wdfa46d363ca96f99@mail.gmail.com>
From: Jeremy Leibs <leibs@willowgarage.com>
Date: Sat, 10 Oct 2009 19:07:57 -0700
Message-ID: <92be2ef30910101907h68aa44c0tad678f036f19c8f3@mail.gmail.com>
Subject: Re: ERESTARTSYS escaping from sem_wait with RTLinux patch
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Blaise Gassend <blaise@willowgarage.com>,
       LKML <linux-kernel@vger.kernel.org>, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 12:08 PM, Jeremy Leibs <leibs@willowgarage.com> wrote:
> Thomas, thanks for the quick reply.
>
> On Sat, Oct 10, 2009 at 10:59 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
-----snip-----
>>
>> 1) Does that happen with 2.6.31.2-rt13 as well ?
>
> I am nearly certain we saw the problems with the newer kernel as well,
> although that was back with a much less concise test and I've since
> reinstalled over that machine in the process of trying a number of
> different 32/64 hardy/jaunty configurations on different hardware.
> I'll do a fresh install of that particular kernel with default
> configuration options on our hardware and let you know a little later
> today.

Running on fresh install of 64 bit jaunty:

leibs@c1:~$ uname -rv
2.6.31.2-rt13 #1 SMP PREEMPT RT Sat Oct 10 15:34:13 PDT 2009

leibs@c1:~$ python threadprocs8.py
sem_wait: Unknown error 512
Fatal Python error: ceval: orphan tstate
Aborted
