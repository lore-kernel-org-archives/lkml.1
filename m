Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab0CEQqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:46:33 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:56255 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab0CEQqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:46:31 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zz98dN936eM4015L62a3Lzz1202hzzz32i6bh2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYTIL5-01-MX8-02
X-M-MSG: 
Date: Fri, 5 Mar 2010 17:46:15 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Paul Mackerras <paulus@samba.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing
Message-ID: <20100305164615.GY13205@erda.amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
 <20090803112220.GA22936@elte.hu>
 <20090803072522.1d90f15c@infradead.org>
 <20090804201109.GA21386@elte.hu>
 <20090805123501.GF14610@erda.amd.com>
 <84144f020908060031vb48b983m6e6b1b521e01d6aa@mail.gmail.com>
 <20090806105134.GD11236__37984.4768475325$1249556453$gmane$org@elte.hu>
 <87ocjcqcdj.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87ocjcqcdj.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 05 Mar 2010 16:46:15.0616 (UTC) FILETIME=[5F202400:01CABC83]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.02.10 15:51:04, Andi Kleen wrote:
> That said the biggest problem with oprofile right now that the
> new buffer it's using is quite a lot less reliable and drops
> events left and right on any non trivial load. That makes
> oprofile very unreliable, especially in call graph mode.

(cc'ing Steve)

Andi,

the tests I run with oprofile do not indicate unreliable ring_buffer
behavior. Maybe my use cases and loads are different. Can you describe
a setup where this may happen for sure? What is the impact, do you
have lost samples or inconsistent buffer data? Is the data loss in
kernel or user space? Also, I am not aware that the ring_buffer is
unreliable for ftrace or tracepoints, where it is heavily used. I
really want to find the root cause here.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

