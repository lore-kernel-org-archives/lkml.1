Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYCSThG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYCSThG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYCST2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:28:51 -0400
Received: from gw.goop.org ([64.81.55.164]:55868 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbYCST2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:28:49 -0400
Message-ID: <47E12D39.2000207@goop.org>
Date: Wed, 19 Mar 2008 08:11:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
References: <patchbomb.1205797011@localhost> <1205918565.4112.61.camel@zakaz.uk.xensource.com>
In-Reply-To: <1205918565.4112.61.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Mon, 2008-03-17 at 16:36 -0700, Jeremy Fitzhardinge wrote:
>   
>> Hi Ingo,
>>
>> This is a great big pile of x86 unification and Xen bugfix patches.
>> They build and boot for me on 64-bit and 32-bit (PAE and non-PAE).
>>     
>
> FWIW I tested in a PAE Xen guest on 32 and 64 bit h/v and it was fine
> including running ddcprobe which was my most recent issue. I can't see
> why this would fix it though.
>   

I'm actually having problem booting 32-on-64 hvm guests.  Specifically 
the Fedora installer crashes fairly early on:

Freeing unused kernel memory: 280k freed
Write protecting the kernel read-only data: 844k
input: ImExPS/2 Generic Explorer Mouse as /class/input/input2
[9;0][8]
Greetings.
anaconda installer init version 11.3.0.50 starting
mounting /proc filesystem... done
creating /dev filesystem... done
mounting /dev/pts (unix98 pty) filesystem... done
mounting /sys filesystem... done
anaconda installer init version 11.3.0.50 using a serial console
trying to remount root filesystem read write... done
mounting /tmp as ramfs... done
running install...
running /sbin/loader
loader received SIGSEGV!  Backtrace:
[0x804a030]
[0x110420]
[0x816a7c8]
[0x81697a5]
[0x805b626]
[0x805b72b]
[0x805c153]
[0x804af81]
[0x8175004]
[0x8048151]
install exited abnormally [1/1] 
sending termination signals...done
sending kill signals...done
disabling swap...
unmounting filesystems...
        /proc done
        /dev/pts done
        /sys done
        /tmp/ramfs done
you may safely reboot your system


Seen anything like that?

> I thought for a second when you said it booted on 64 bit you meant 64
> bit Xen guest, do you know how that stuff ﻿is going?
>   

Last I heard, they got something booting, but it wasn't very clean.  I 
need to resync with Eduardo.  A lot of these changes were intended to 
make that effort easier, but it would be nice to confirm ;)  Doesn't 
look like http://git.et.redhat.com/?p=xen-pvops-64.git;a=summary has 
changed much lately.

    J
