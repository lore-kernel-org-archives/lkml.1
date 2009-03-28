Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbZC1SDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbZC1SDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 14:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZC1SDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 14:03:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:49990 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZC1SDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 14:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=j0hF1uHAJLLrquTZ+0GBsP9aqH7fvx4jEY+d/8fJG7fm1ciDholbpjVrcCYsOdaK1/
         rIwhdnk7319Ry/06n1wjcHhfb12BfhLcVuDcP2b2q1cq2jr/x7bm5W4iIX3cTw82L1pB
         wR+5QxsAjvxM3FgnfV4ACuaTRZC+S0mjJFf3g=
MIME-Version: 1.0
Date: Sat, 28 Mar 2009 12:03:13 -0600
Message-ID: <9b1675090903281103r612ec934odc7430008eeb9c94@mail.gmail.com>
Subject: kernel sluggish bug 12309
From: Trenton Adams <trenton.d.adams@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12309

Hi Guys,

Is this the right place to be discussing this?  If not, let me know.

FYI, I am on x86_64.

This bug is very debilitating for me, especially on my home system.
So, I recently read about "git bisect", when I was reading an xorg
bug.  So, I thought hey, I should give that a try to try and narrow
down which kernel version gives me a problem.  That would certainly
help you guys in finding this EXACT issue, and me getting a reasonable
fix. :D

Anyhow, I started with cloning Linus' git kernel tree, and then
checking out 2.6.17.  2.6.17 was working for me on my work machine
when I was using gentoo 32-bit, so I thought that was a good place to
start.  It seems like it's better performance.

So, before starting the git bisect stuff, I wanted to try an earlier
version.  So, I checked out 2.6.16, but it refuses to compile.  Can
someone help me?

FYI, I did an mrproper, and then copied my config back to ".config".

  AS      arch/x86_64/ia32/vsyscall-sysenter.o
  SYSCALL arch/x86_64/ia32/vsyscall-sysenter.so
collect2: ld terminated with signal 11 [Segmentation fault]
/usr/lib/gcc/x86_64-pc-linux-gnu/4.1.2/../../../../x86_64-pc-linux-gnu/bin/ld:
i386:x86-64 architecture of input file
`arch/x86_64/ia32/vsyscall-sysenter.o' is incompatible with i386
output
make[1]: *** [arch/x86_64/ia32/vsyscall-sysenter.so] Error 1
make: *** [arch/x86_64/ia32] Error 2

Thanks.
