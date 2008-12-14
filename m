Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYLNXf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYLNXf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 18:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYLNXfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 18:35:20 -0500
Received: from smtp3.ono.com ([62.42.230.176]:49963 "EHLO resmaa14.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751036AbYLNXfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 18:35:19 -0500
Date: Mon, 15 Dec 2008 00:35:15 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Bugs on aspire one A150
Message-ID: <20081215003515.600c0704@werewolf.home>
In-Reply-To: <1229174138.24940.9.camel@maxim-laptop>
References: <491506DB.1070000@gmail.com>
	<1229174138.24940.9.camel@maxim-laptop>
X-Mailer: Claws Mail 3.6.1cvs75 (GTK+ 2.14.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008 15:15:38 +0200, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> 
> So, big thanks for everything.
> 
> Now aspire one linux support is very close to perfect,

And this is the past one in my list...

With latest updates (kernel rc8, intel video driver 2.5.1, ...), MTRRs are
setup ok:

one:~# cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size=  512MB, count=1: write-back
reg01: base=0x01f500000 (  501MB), size=    1MB, count=1: uncachable
reg02: base=0x01f600000 (  502MB), size=    2MB, count=1: uncachable
reg03: base=0x01f800000 (  504MB), size=    8MB, count=1: uncachable

But X still has some kind of problem:

[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20080730 on minor 0
X:2877 conflicting memory types 20000000-30000000 write-combining<->uncached-minus
reserve_memtype failed 0x20000000-0x30000000, track write-combining, req write-combining
X:2877 conflicting memory types 20000000-30000000 write-combining<->uncached-minus
reserve_memtype failed 0x20000000-0x30000000, track write-combining, req write-combining
X:3008 freeing invalid memtype 20000000-30000000
X:2877 conflicting memory types 20000000-30000000 write-combining<->uncached-minus
reserve_memtype failed 0x20000000-0x30000000, track write-combining, req write-combining
X:3009 freeing invalid memtype 20000000-30000000

Don't know it its a problem, as DRI works and 'gears' (I know, gears is not
a benchmark...) has raised from about 500 in the best times I remember to
750!!.
Perhaps if X could set its MTRR things would be even faster ??

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.27.5-desktop-1mnb (gcc 4.3.2 (GCC) #1 Sun Nov
