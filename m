Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYFXDBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYFXDBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 23:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYFXDBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 23:01:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:45188 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbYFXDBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 23:01:38 -0400
Message-ID: <2ffbcf00806232001o4bd314f4kc590e43b4ab27076@mail.gmail.com>
Date: Tue, 24 Jun 2008 05:01:37 +0200
From: william <william@waisse.org>
To: linux-kernel@vger.kernel.org
Subject: strange freeze with VIA C7 dedicated server and libc 2.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: b5fa4f0a26b412ff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 hi all

I am using gentoo linux on 3 boxes ( low cost dedicated servers ) who
are using VIA C7 CPU, all of them were running very well for
more than 1 year.

 I recently emerge --sync and emerge -DNatuv world  ( gentoo updates )
on 2 of the boxes.

 The 2 upgraded boxes ( now running glibc-2.6.1 )are now now freezing very
often, most often when under heavy load ( >2 load )

 There is nothing in the logs, I checked syslog, kern.log . . . nothing, no
clue.
 the other box, still running glibc-2.5-r4 , is working very well as before.

 I tried many kernel, from 2.6.18 to 2.6.24, with and without hardened profile,
its the same

 I'm not the only one, many people in france had this problem, debian users who
downgraded libc could go back to a stable server, but with gentoo, downgrading
libc seems pretty dangerous.

 All the reported problems are in french cause it seems only dedibox (
http://dedibox.fr ) provides low cost servers using VIA C7 processor ), if
needed i can provide many webpages where people describe the problem in french
( google "dedibox freeze libc" gives some ), but I found nothing in english, if
you contact dedibox.fr admins they will confirm the problem, perhaps they even
could accept to provide a box for testing, who knows . . .

 I have nothing to give you, nothing in the log, the box just stop working as
if power had been switched off

 The problem happened at least on debian and gentoo which are the most used
linux distros on dedibox VIA C7 servers.

 The exact processor is :
processor       : 0
vendor_id       : CentaurHauls
cpu family      : 6
model           : 10
model name      : VIA Esther processor 2000MHz
stepping        : 9
cpu MHz         : 1995.084
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge cmov pat
clflush acpi mmx fxsr sse sse2 tm pni est tm2 rng rng_en ace ace_en ace2
ace2_en phe phe_en pmm pmm_en
bogomips        : 3994.49
clflush size    : 64

Reproducible: Always

Steps to Reproduce:
1. box using VIA C7 processor with glibc
2. heavy load >2
3. wait 1 or 2 hours

 The complete bug report with attachments ( logs and kernel .config )
and gentoo maintainers comments is here :

http://bugs.gentoo.org/show_bug.cgi?id=228263

 I have no clue this is a linux kernel bug, since all the kernels I
tried ( from 2.6.18 to 2.6.24 ) are working perfectly before upgrading
to the new libc, but the gentoo maintainers finally told me I should
post on the LKML.

 here is the last comment from the gentoo maintainer :
"If the kernel completely locks up then that is a kernel bug or a hardware bug.
It shouldn't be possible to lock up the kernel, regardless of what userland
such as glibc does. Presumably the newer glibc is doing something different
that is triggering the bug. Regardless of what that is and whether it should be
doing it, it shouldn't completely hang the kernel."

 Feel free to ask more details, I'll be happy to provide answers.
( no need to cc me I subscribed to follow this problem )

-- 
Cordialement

 William Waisse
  http://waisse.org | http://neoskills.com
   http://cahierspip.ww7.be | http://feeder.ww7.be
