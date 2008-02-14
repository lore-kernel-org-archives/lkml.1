Return-Path: <linux-kernel-owner+w=401wt.eu-S935492AbYBNBOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935492AbYBNBOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:14:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935217AbYBNBMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:12:35 -0500
Received: from simmts12-qfe0.srvr.bell.ca ([206.47.199.141]:63543 "EHLO
	simmts12-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935173AbYBNBMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:12:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAALYjs0eOonh+/2dsb2JhbAAIihKHeZwn
Message-ID: <47B39577.3020603@gmail.com>
Date: Wed, 13 Feb 2008 21:12:23 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Latency issues with x86.git
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

I have encountered (a handful of times in the past few months) some real
interactivity problems on my system.  Moving the mouse or typing a key
on the keyboard takes around a second to show any response.  Once I
perform a reboot, the problem is gone again.  I am currently running
x86.git mm branch, but I switch between that branch, mainline git, and
mm kernels, so I cannot guarantee on which trees I have or have not seen
the problem.

It seems to have started around the time that CFS came into being, but
it might be something completely unrelated.

When it happened this evening, I ran the cfs-debug-info.sh script to
which you had referred me in another thread.  I'm not sure if this helps
to debug the problem, but it was all I could think to try.  I have
LatencyTOP in my kernel, so I guess I could try the userspace tool as
well the next time.

The output of the script is at:

http://personal.nbnet.nb.ca/kwin/cfs-debug-info-2008.02.13-20.56.38


Unfortunately, I cannot reproduce the problem intentionally - it only
happens once a month or so.

If there is any other info you need, please let me know, or any
suggestions for what to try the next time.

Thanks,

-- 
Kevin Winchester
