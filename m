Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZA3RFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZA3RFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 12:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZA3RFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 12:05:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:53773 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbZA3RFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 12:05:36 -0500
Message-ID: <49833350.1020809@kernel.org>
Date: Sat, 31 Jan 2009 02:05:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: #tj-percpu has been rebased
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 30 Jan 2009 17:05:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

tj-percpu has been rebased.  Sorry, the previous tree was discarded
because it was missing several patches in the middle but rebasing on
top of new misc/tj-percpu shouldn't be too difficult.  What have
happened are...

* Rebased on top of the current 2.6/master[1].

* hardirq unification patches restored.

* linker bug fix and xen fix patches applied.

* misc/tj-cpus4096 created as tip/cpus4096 + uv_flush_tlb_others()
  cleanup patch (w/ Cliff Wickman's fixes folded in) and got merged
  into misc/tj-percpu.

* misc/tj-stackprotector created as tip/stackprotector^ + three
  patches.  The back tracked commit is merge with the previous
  core/percpu.  misc/tj-stackprotector got merged into misc/tj-percpu.

So, all in all, the rebase is complete.  No patch is lost but on
hindsight it should really have been done by pulling in 2.6/master.
The end result is the same anyway sans slightly simpler merge tree and
it definitely doesn't feel like it's worth the trouble.  Well, what's
done is done.  Please keep sending patches.

The git vector is as always...

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Thanks.

-- 
tejun

[1] f2257b70b0f9b2fe8f2afd83fc6798dca75930b8
