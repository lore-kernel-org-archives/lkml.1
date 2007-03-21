Return-Path: <linux-kernel-owner+w=401wt.eu-S933944AbXCUXPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944AbXCUXPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933903AbXCUXPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:15:54 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:49598 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933944AbXCUXPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:15:53 -0400
Date: Thu, 22 Mar 2007 00:11:57 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andi Kleen <ak@suse.de>, David Howells <dhowells@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] : Is /proc/kcore still usefull and/or maintained ?
In-Reply-To: <4601B89E.3060605@cosmosbay.com>
Message-ID: <Pine.LNX.4.61.0703220011080.9555@yvahk01.tjqt.qr>
References: <200703211840.53242.maximlevitsky@gmail.com> <20070321222106.GF6057@elf.ucw.cz>
 <200703212339.02972.rjw@sisk.pl> <4601B89E.3060605@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 21 2007 23:58, Eric Dumazet wrote:
> Hi all
>
> On i386 , 2.6.20 / 2.6.21-rc4 :
>
> # gdb vmlinux /proc/kcore
> error
> # file /proc/kcore
> error

00:11 ichi:/hld # file /proc/kcore
/proc/kcore: ELF 32-bit LSB core file Intel 80386, version 1 (SYSV),
SVR4-style, from 'vmlinux'
00:11 ichi:/hld # hexdump -C /proc/kcore | head -n5
00000000  7f 45 4c 46 01 01 01 00  00 00 00 00 00 00 00 00  |.ELF............|
00000010  04 00 03 00 01 00 00 00  00 00 00 00 34 00 00 00  |............4...|
00000020  00 00 00 00 00 00 00 00  34 00 20 00 03 00 00 00  |........4. .....|
00000030  00 00 00 00 04 00 00 00  94 00 00 00 00 00 00 00  |................|
00000040  00 00 00 00 a8 06 00 00  00 00 00 00 00 00 00 00  |................|
00:11 ichi:/hld # uname -rm
2.6.20.2 i686

>
>
> Apparently we can not llseek() anymore on this file (returns -EINVAL)
>
> On x86_64 2.6.20 it's working
>
> # file /proc/kcore
> /proc/kcore: ELF 64-bit LSB core file x86-64, version 1 (SYSV), SVR4-style
>
>
> On i386 2.6.14 it's working too.
>
> Eric
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

Jan
-- 
