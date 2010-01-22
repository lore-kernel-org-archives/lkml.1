Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978Ab0AVO40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab0AVO40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777Ab0AVOzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:55:35 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:34536
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752934Ab0AVOz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:55:29 -0500
X-SpamScore: 0
X-BigFish: VPS0(zz146fKzz1202hzzz32i87h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWNLFH-02-1LA-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@googlemail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/12] perf/core: x86 and AMD pmu updates
Date: Fri, 22 Jan 2010 15:21:55 +0100
Message-ID: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 22 Jan 2010 14:54:55.0158 (UTC) FILETIME=[DBE9A560:01CA9B72]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know there is some ongoing work by Stephane in this code too, but I
want to submit the patches anyway for review. If necessary I will
rebase the patch set on top of Stephanes patches. Anyway, this patch
set applies to tip/perf/core and can be pulled from here too:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git perf

The patches contain changes, updates and code reworks I made during
reviewing the code and implementing IBS for perf_events. Patches for
IBS I will submit in a later series. These patches will include an
implementation that extends the ABI to support model specific hardware
pmu features.

In this patch set I made some model specific pmu code generic and vice
versa. The event constraint handler works now for AMD pmu too. Fixed
counter code that is only need on Intel cpus is now model
specific. Also the MSR masks were unified, where the hardware
implementation is the same for all cpus.

-Robert


