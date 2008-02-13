Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbYBMQGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbYBMQGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757977AbYBMQGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:06:16 -0500
Received: from wr-out-0708.google.com ([64.233.184.245]:50676 "EHLO
	wr-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433AbYBMQGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:06:15 -0500
MIME-Version: 1.0
Message-ID: <04a37899-eb7b-43ae-a7ab-1928ca1a0e35@s12g2000prg.googlegroups.com>
Date: Wed, 13 Feb 2008 08:05:58 -0800 (PST)
Path: s12g2000prg.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Complaints-To: groups-abuse@google.com
Injection-Info: s12g2000prg.googlegroups.com; posting-host=15.235.153.104; 
	posting-account=pchT0goAAABvuUrREVzOewWkpU1HL5XN
NNTP-Posting-Host: 15.235.153.104
References: <fa.d3EyknDimPJIlJNA2Y25+wmntNM@ifi.uio.no>
User-Agent: G2/1.0
X-HTTP-Via: 1.1 HOUWEBPROXY01
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; 
	rv:1.8.1.10) Gecko/20071115 Firefox/2.0.0.10,gzip(gfe),gzip(gfe)
Subject: Re: stuck with 2.6.23.14 on x86_64
From: mikem13@sbcglobal.net
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 12, 8:13 am, Fabio Coatti <c...@ferrara.linux.it> wrote:
> Hi all,
> I'm stuck in a weird situation: I'm unable to go beyond 2.6.23.14, so to fix
> the splice bug I've had to apply by hand the patch. (x86_64)
>
> Basically, with 2.6.24.2 (the same with 2.6.24 and .1), tha machine won't boot
> due to a problem with cciss driver, that prevents to find the / partition.
> (bug described here: Kernel Bug Tracker Bug 9859http://bugzilla.kernel.org/show_bug.cgi?id=9859);
>
> With kernels 2.6.23, the lastest that I can compile is 2.6.23.14; starting
> from .15 (and .16) I get this message:
>
> ======================
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `acpi_init':
> bus.c:(.init.text+0x1713): undefined reference to `pm_flags'
> bus.c:(.init.text+0x1756): undefined reference to `pm_flags'
> ======================
>
> All .config are the same, (make oldconfig) beside the obvious differences
> between .23 and .24
>
> Hardware: x86_64 AMD 2216HE
> SCSI controller: HP Smart Array E200i Controller
> Compiler: gcc (GCC) 4.1.1
> binutils: 2.16.1
>
> On a x86 machine, Intel(R) Xeon(TM) CPU 3.20GHz
> with a cciss0: HP Smart Array 6i Controller,
> the 2.6.24.2 compiles just fine and works, so the cciss problems seems related
> only to E200i controller.
>
> Right now, on AMD64 machines, I'm forced to patch by hand the kernel, that's
> quite uncomfortable :)
>
> Can someone point me in the right direction to get out of this situation? Of
> course I can provide any further information. (.config not inlcuded now to
> avoid cluttering  )
>
> Thanks for any answer.
>
> --
> Fabio "Cova" Coatti    http://members.ferrara.linux.it/cova
> Ferrara Linux Users Group          http://ferrara.linux.it
> GnuPG fp:9765 A5B6 6843 17BC A646  BE8C FA56 373A 5374 C703
> Old SysOps never die... they simply forget their password.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majord...@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Fabio, Can you please post your boot messages in bug 9859.

Thanks,
mikem
