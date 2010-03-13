Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab0CMNPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 08:15:34 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:61708 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759166Ab0CMNPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 08:15:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=cU7jKGyVeSCYMJPwa2QTMOaQgnLg9oN4qnl5kbYQNfg0Pzg4FuLTmOUvhZ5uemK9Po
         esNV5e4VR6K42SuAxaypExSr3jMUQiRP4L4boklNYWokFrjRHKOzlZ7PX9oAyfTTx4tD
         rNuRbffVkGrutQlFNT5N1GelWBAGPOXKQbac8=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: Re: scary warning in atags.c -- 2.6.34-rc1
Date: Sat, 13 Mar 2010 14:15:00 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-2-amd64; KDE/4.3.4; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
References: <20100313103913.GA9812@elf.ucw.cz>
In-Reply-To: <20100313103913.GA9812@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003131415.00156.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne So 13. března 2010 11:39:13 Pavel Machek napsal(a):
> Hi!
> 
> Scary warning on HTC Dream:
> 
> [    0.220000] ------------[ cut here ]------------
> [    0.220000] WARNING: at arch/arm/kernel/atags.c:60
> init_atags_procfs+0x5c/0xe8()
> [    0.220000] Modules linked in:
> [    0.220000] [<c0025250>] (unwind_backtrace+0x0/0xdc) from
> [<c0032e1c>] (warn_slowp)
> [    0.220000] [<c0032e1c>] (warn_slowpath_common+0x4c/0x80) from
> [<c000b4b8>] (init_)
> [    0.220000] [<c000b4b8>] (init_atags_procfs+0x5c/0xe8) from
> [<c002033c>] (do_one_i)
> [    0.220000] [<c002033c>] (do_one_initcall+0x5c/0x1bc) from
> [<c0008584>] (kernel_in)
> [    0.220000] [<c0008584>] (kernel_init+0x94/0x148) from [<c00217b4>]
> (kernel_thread)
> [    0.220000] ---[ end trace 1b75b31a2719ed1c ]---
> [    0.230000] bio: create slab <bio-0> at 0
> [    0.230000] Switching to clocksource dg_timer
> 
> Hmm, what are atags anyway?
> 							Pavel
> 
Atags are data passed by the bootloader to kernel (like memory size, machine id 
...).
