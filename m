Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbZFMHGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbZFMHGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 03:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbZFMHF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 03:05:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15181 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479AbZFMHF4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 03:05:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Mg+Q/zOQLRc6CrQ22MkpEdnV5R+KdW0PSU9yEaWLCH8LN+hgnsWxoGvv0Qjgkc0Bj
	XwbBWANj5XSAvDV+0YKTw==
MIME-Version: 1.0
In-Reply-To: <a55d774e0906120344p57226dd4ve526f274a2bf7c8e@mail.gmail.com>
References: <20090611132134.GA11199@atomide.com>
	 <20090611140624.GS795@n2100.arm.linux.org.uk>
	 <alpine.LFD.2.00.0906111314510.31536@xanadu.home>
	 <4A3175AC.9070100@bluewatersys.com>
	 <alpine.LFD.2.00.0906112105220.31536@xanadu.home>
	 <4A31AECA.6070303@bluewatersys.com>
	 <alpine.LFD.2.00.0906112138090.31536@xanadu.home>
	 <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com>
	 <20090612103521.GD18682@elf.ucw.cz>
	 <a55d774e0906120344p57226dd4ve526f274a2bf7c8e@mail.gmail.com>
Date: Sat, 13 Jun 2009 00:05:50 -0700
Message-ID: <a55d774e0906130005v5a35aa60ybabde470ff44cf77@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Nicolas Pitre <nico@cam.org>, Ryan Mallon <ryan@bluewatersys.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 3:44 AM, Brian Swetland<swetland@google.com> wrote:
> On Fri, Jun 12, 2009 at 3:35 AM, Pavel Machek<pavel@ucw.cz> wrote:
>>
>> I still can't get it to boot :-(.
>
> I think the cupcake userspace and the latest 2.6.29 kernel aren't
> getting along.  I'm putting together instructions for building a
> minimal userspace (what we call tiny android -- and what I use for
> bringup and kernel testing), and once I've had a chance to verify that
> everything works end-to-end with the latest kernel, donut branch, and
> have verified this on ADP1, I'll send an update.  Probably some time
> over the weekend.

For anyone who wants a minimal android userspace image (handy for
bringup and test on adp1, etc), I've thrown together a small project
based on the android stack but including only the bare essentials
(libc, libm, linker, init, shell, some commandline tools, adbd, etc):
http://github.com/swetland/tinydroid/tree/master

It's a much smaller checkout (~100MB), and builds much faster (~1
minute or less on a modern, fast box), and will get you a ramdisk.img
and a minimal system.img that play nicely with the android-msm-2.6.29
kernel.  Final images turn up in out/target/product/generic.

I suspect it wouldn't be hard to just get something like a full
arm-debian distribution booting, but that's not something I've ever
tried.

Brian
