Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbZFVUxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbZFVUxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZFVUxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:53:38 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:48731
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256AbZFVUxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:53:37 -0400
X-IronPort-AV: E=Sophos;i="4.42,271,1243807200"; 
   d="scan'208";a="29986916"
Message-ID: <4A3FEF75.2020804@inria.fr>
Date: Mon, 22 Jun 2009 22:54:13 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>
Subject: [perf] howto switch from pfmon
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am trying to play with perfcounters in current git (actually in latest
mmotm). I'd like to reproduce what I previously did with pfmon, but I
couldn't so far.

Something like
    pfmon --follow-exec 'foobar' -e
CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE:LOCAL_TO_0,CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE:LOCAL_TO_1
-- <shell script>
gives the number of memory accesses to dram node #0 and #1 for all
processes whose name matches 'foobar'.

So there are several questions here:
1) is it possible to specify counter names like the above or do we have
to use raw counter numbers? I tried raw numbers from [1] without
success. How am I supposed to find and specify these raw numbers?
2) how do we specify "subevents"?
3) is there anything similar to --follow-exec, or --follow-pthreads for
getting separated outputs for each thread?

I guess there are still a lot of things on the TODOlist but I'd like to
understand a bit more where things are going. Sorry I didn't read all
the archives about this, there are way too many of them recently :)

thanks,
Brice

[1]
https://aiya.ms.mff.cuni.cz/svn/rip/trunk/doc/devel/native_events_barcelona.txt

