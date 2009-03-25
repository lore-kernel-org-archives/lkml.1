Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZCYQls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZCYQls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZCYQlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:41:39 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:12188 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZCYQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:41:38 -0400
X-BigFish: VPS-25(zz1432R98dR1805Mzz1202hzzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <49CA5EA9.2080106@am.sony.com>
Date: Wed, 25 Mar 2009 09:41:13 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <49C95EAF.7030901@gmail.com> <20090324224857.GE5975@nowhere> <20090325084248.GF4697@n2100.arm.linux.org.uk> <20090325085418.GA2341@elte.hu>
In-Reply-To: <20090325085418.GA2341@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2009 16:41:15.0044 (UTC) FILETIME=[8374BE40:01C9AD68]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Unwinding is not realistic or desired for the function tracer - it 
> runs in every kernel function so performance is paramount.
> 
> So, if i understood you correctly, an OABI_COMPAT and FRAME_POINTERS 
> dependency has to be added to the ARM HAVE_FUNCTION_GRAPH_TRACER 
> Kconfig rule.

This, unfortunately, is a problem for me.  All my ARM
projects are now using EABI.  If the unwinding looks like
it has too much overhead, I'll do some research on the
-finstrument-functions (__cyg_profile_func_enter/exit) approach.

I'm not sure, however, if it's possible to integrate this with
the dynamic tracing mechanisms, though.  So something may have
to give to get this supported on ARM.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

