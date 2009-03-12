Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbZCLQwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbZCLQwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbZCLQwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:52:44 -0400
Received: from slb-smtpout-01.boeing.com ([130.76.64.48]:58399 "EHLO
	slb-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbZCLQwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:52:43 -0400
X-Greylist: delayed 2098 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 12:52:43 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Build error with realtime patch on ppc platform
Date: Thu, 12 Mar 2009 09:16:17 -0700
Message-ID: <1A35CC2FF2016840923376BD5C2B3DAC0B6791EF@XCH-NW-6V1.nw.nos.boeing.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Build error with realtime patch on ppc platform
Thread-Index: AcmjLd92PeMsZPjbTq2EQvfp+8LEBw==
From: "Tate, Patrick O" <patrick.o.tate2@pss.boeing.com>
To: <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       "Lykken, Allan D" <allan.d.lykken@boeing.com>
X-OriginalArrivalTime: 12 Mar 2009 16:17:16.0954 (UTC) FILETIME=[02EADFA0:01C9A32E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo

My name is Pat Tate and I was trying to build a kernel with the realtime
patch on a powerpc. We are using the YDL 4.1 distribution.
I pulled down the linux 2.6.29-rc6 with the realtime
patch-2.6.29-rc6-rt3.

But after applying the patch and executing the make I get the following
error in the spinlock_types.h

************************************************************************
***************************
> make
scripts/kconfig/conf -s arch/powerpc/Kconfig
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-powerpc
  CC      kernel/bounds.s
  GEN     include/linux/bounds.h
  CC      arch/powerpc/kernel/asm-offsets.s
In file included from include/linux/spinlock.h:102,
                 from include/linux/seqlock.h:34,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:54,
                 from arch/powerpc/kernel/asm-offsets.c:17:
include/linux/spinlock_types.h:38: error: syntax error before
"__raw_spinlock_t"
include/linux/spinlock_types.h:38: warning: no semicolon at end of
struct or uni
on
include/linux/spinlock_types.h:49: error: syntax error before '}' token
include/linux/spinlock_types.h:49: warning: useless keyword or type name
in empt
y declaration
include/linux/spinlock_types.h:49: warning: empty declaration
include/linux/spinlock_types.h:54: error: syntax error before
"__raw_rwlock_t"
include/linux/spinlock_types.h:54: warning: no semicolon at end of
struct or uni
on
include/linux/spinlock_types.h:65: error: syntax error before '}' token
include/linux/spinlock_types.h:65: warning: useless keyword or type name
in empt
y declaration
include/linux/spinlock_types.h:65: warning: empty declaration
************************************************************************
***************************

I was told by Eduard Munteanu that you are the contact in the patch file
so I thought I'd pass it by you and
See if you have an answer or some ideas.

If not would you know who might be a good contact to maybe work thru
this error.

Thanks for any help 

Pat

