Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZABRwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZABRwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbZABRwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:52:16 -0500
Received: from mail.lang.hm ([64.81.33.126]:38232 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757056AbZABRwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:52:15 -0500
Date: Fri, 2 Jan 2009 10:54:15 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Valdis.Kletnieks@vt.edu
cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Bryan Donlan <bdonlan@gmail.com>,
       Ingo Brueckl <ib@wupperonline.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86 (Linux Tiny): configure out support for some processors
In-Reply-To: <14241.1230913598@turing-police.cc.vt.edu>
Message-ID: <alpine.DEB.1.10.0901021048050.21408@asgard.lang.hm>
References: <495d2974@wupperonline.de> <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com> <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com> <20090102093801.GD1975@elte.hu> <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com>
 <11444.1230910752@turing-police.cc.vt.edu>            <alpine.DEB.1.10.0901020849180.20509@asgard.lang.hm> <14241.1230913598@turing-police.cc.vt.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jan 2009, Valdis.Kletnieks@vt.edu wrote:

> On Fri, 02 Jan 2009 08:51:28 PST, david@lang.hm said:
>> having things outside of the embedded menu depend on embedded makes it
>> hard for people to figure out what they need to do to disable specific
>> things.
>
> Odd, I can do a 'make menuconfig', do a /EARLY_PRINTK, and see:
>
> Symbol: EARLY_PRINTK [=y]                                               x
>  x Prompt: Early printk                                                    x
>  x   Defined at arch/x86/Kconfig.debug:33                                  x
>  x   Depends on: EMBEDDED                                                  x
>  x   Location:                                                             x
>  x     -> Kernel hacking
>
>> if you follow the logic you are providing to it's logical conclusion you
>> may as well put all kernel config options under "I really know what I'm
>> doing" top level lockout
>
> Hey, I didn't make up that logic. ;)
>
> A large percentage of the kernel config options are things that really *could*
> be one way or the other for any given system.  Maybe you want ext4, maybe you
> don't.  Maybe you need process accounting, maybe you don't.  So they don't go
> under EMBEDDED.  But we can be 98% sure that they probably want PRINTK.

is there an easy way to pull the list of what symbols depend on EMBEDDED?

David Lang
