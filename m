Return-Path: <linux-kernel-owner+w=401wt.eu-S934672AbXLTSGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934672AbXLTSGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764397AbXLTSGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:06:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43664 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764174AbXLTSGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:06:07 -0500
Date: Thu, 20 Dec 2007 19:05:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Subject: [patch/backport] CFS scheduler, -v24.1, for v2.6.23.12, v2.6.22.15
	and v2.6.21.7
Message-ID: <20071220180518.GA1409@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0423]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm pleased to announce the v24.1 CFS backport patches.

It is a full backport of the latest & greatest upstream scheduler code 
to v2.6.23.12, v2.6.22.15 and v2.6.21.7. (Note: the upstream 2.6.24-rc5 
and soon-to-be-released v2.6.24-rc6 kernels already include the v24.1 
CFS code.)

The CFS patches can be downloaded from the usual place:

     http://people.redhat.com/mingo/cfs-scheduler/

No major user-visible changes were done since v24, only a number of 
bugfixes. The delta since v24 is:

  8 files changed, 339 insertions(+), 484 deletions(-)

if you'd like to make sure that the v2.6.24 kernel's scheduler handles 
your workloads just fine, or if you just want to try the latest then you 
can try one of these backport kernels. (or try the latest 2.6.24-rc 
kernel)

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome!

	Ingo
