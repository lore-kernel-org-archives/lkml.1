Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbZCXTj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbZCXTj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbZCXTjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:39:31 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:32542
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757317AbZCXTja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:39:30 -0400
X-BigFish: VPS-15(zz4015Ma65Rzz1202hzzz2fh6bh65h)
X-Spam-TCS-SCL: 4:0
Message-ID: <49C936CA.8070800@am.sony.com>
Date: Tue, 24 Mar 2009 12:38:50 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Anyone working on ftrace function graph support on ARM?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Mar 2009 19:38:52.0113 (UTC) FILETIME=[2926AC10:01C9ACB8]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM and FTRACE people,

Is anyone working on function graph support for ARM?

I haven't done much ARM assembly, but the Intel mechanism
for the return hook looks fairly straightforward,
and I thought I'd take a shot at implementing it on ARM.

But if someone else is already doing it, I'd rather work
with them.

BTW - I turned on -finstrument-functions on ARM, and it seems
to work OK (with the exception being that I don't see evenly matched
calls and returns).  For this latter reason, I'm going to
start with an implementation that copies the return hook
used by x86, with a fallback to using __cyg_profile_... instead
of mcount, if the hook approach proves too hard for me on ARM.

My ultimate goal is to add function duration filtering, which
is one of the nicer features of KFT (an older tracer I used
to maintain out-of-mainline).  With all the ftrace and ringbuffer
support already in mainline, this shouldn't be too hard, but
I need to start with basic graph support on ARM first.

Any comments or feedback on the approach, or on current plans
to extend ftrace support on ARM, before I get too far along,
are welcome.

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

