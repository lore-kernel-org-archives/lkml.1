Return-Path: <linux-kernel-owner+w=401wt.eu-S1761106AbZDXRZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761106AbZDXRZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbZDXRZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:25:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:6421 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbZDXRZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=F7T8vuiS17nExoI5DKPbDcBsrA+mXBnUtNH8BJXDeZdomx8ikWxMohYc+2am7a1pHj
         bllrpd1DOJreD9AI2PytepRq0sioqMO1GU/wuM8SAjUsZKXKoK0Y8i6sNMV6yOW/StPQ
         Z62EGyqVbONXrIEqQE5/jySnVTIwjVaU0Lmg4=
Subject: [GIT] kernel function tracing support for linux-mips
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: loongson-dev@googlegroups.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Sat, 25 Apr 2009 01:25:25 +0800
Message-Id: <1240593925.7456.62.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, all

two different patches have been ported to linux-mips/loongson for kernel
function tracing, they are KFT and ftrace.

both of them can be used to trace kernel functions, but they are based
on different implementations(will be introduced later).

KFT is released as a kernel patch, and maintained by DSLab currently,
the latest versions can be found at ftp://dslab.lzu.edu.cn/pub/kft

ftrace is originally from the real time linux extension(RT_PREEMPT,
rt.wiki.kernel.org), and have been merged to the mainline kernel, but
there is no mips implementation in the official kernel. I have ported it
to mips platform, and trying to push it into the mainline kernel.

  * KFT for linux-mips/loongson git tree:

    git://dev.lemote.com/rt4ls.git linux-2.6.29-stable-loongson-kft

  * ftrace for linux-mips/loongson git tree:

    git://dev.lemote.com/rt4ls.git linux-2.6.29-stable-loongson-ftrace

both of them have been tested on yeeloong2f notebook, works well when
compiled kernel in 32bit or 64bit.  

if you want to use them, try to read the documentations for them:

      Documentation/kft.txt       Documentation/kft_kickstart.txt
      Documentation/ftrace.txt

+ more information about KFT & ftrace: 

"Kernel Function Trace (KFT) is a kernel function tracing system, which
uses the "-finstrument-functions" capability of the gcc compiler to add
instrumentation callouts to every function entry and exit. The KFT
system provides for capturing these callouts and generating a trace of
events, with timing details. KFT is excellent at providing a good timing
overview of kernel procedures, allowing you to see where time is spent
in functions and sub-routines in the kernel."
(http://elinux.org/Kernel_Function_Trace)

"ftrace is originally came from work on realtime Linux, it is a
self-contained solution, requiring no user-space tools or support, that
is useful for tracking down problems—not only in the kernel, but in its
interactions with user space as well. 

The name ftrace comes from "function tracer", which was its original
purpose, but it can do more than that. Various additional tracers have
been added to look at things like context switches, how long interrupts
are disabled, how long it takes for high-priority tasks to run after
they have been woken up, and so on. Its genesis in the realtime tree is
evident in the tracers so far available, but ftrace also includes a
plugin framework that allows new tracers to be added easily."
(http://lwn.net/Articles/322666/)


BTW: a "kgcov for linux-mips/loongson" git tree can also be found here, 
     
      git://dev.lemote.com/rt4ls.git linux-2.6.29-stable-loongson-kgcov

    kgcov can be used to kernel profiling, which is originally from
         http://ltp.sourceforge.net/coverage/gcov.php

Best Regards,
Wu Zhangjin

-- 
Wu Zhangjin
DSLab, Lanzhou University, China
www.lemote.com, Jiangsu Province, China

