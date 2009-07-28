Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbZG1I4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbZG1I4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 04:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZG1I4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 04:56:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60975 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZG1I4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 04:56:36 -0400
Date: Tue, 28 Jul 2009 10:56:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Andi Kleen <andi@firstfloor.org>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Robert Richter <robert.richter@amd.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: perf_counters issue with self-sampling threads
Message-ID: <20090728085635.GD15310@basil.fritz.box>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com> <20090727212514.GA25386@basil.fritz.box> <7c86c4470907272213w2ee57080re50dd22a4d73a7e0@mail.gmail.com> <7c86c4470907280151p13e275c0q27a51897351e8e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470907280151p13e275c0q27a51897351e8e0@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 10:51:04AM +0200, stephane eranian wrote:
> [Reposting the message because of stupid MIME-encoding error on my part]
> Andi,
> 
> Looks like SIGPROF is calling _group_send_sig_info(), so I
> think it is subject to the same problem.

So sounds like a whole class of signals can't be POSIX compliant.

Likely others will run into the same problem.

Perhaps should define a new sigaction flag for this to make
it all explicit.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
