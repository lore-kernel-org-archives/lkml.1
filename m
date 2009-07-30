Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbZG3UAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbZG3UAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZG3UAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:00:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:48880 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbZG3UAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:00:51 -0400
Subject: Re: perf_counters issue with self-sampling threads
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: eranian@gmail.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       roland <roland@redhat.com>
In-Reply-To: <20090730192040.GA9503@redhat.com>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
	 <1248869948.6987.3083.camel@twins> <20090729221703.GA25368@redhat.com>
	 <1248953485.6391.41.camel@twins>  <20090730192040.GA9503@redhat.com>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 22:00:03 +0200
Message-Id: <1248984003.4164.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 21:20 +0200, Oleg Nesterov wrote:

> Yes, this allows to send a private signal to sub-thread.
> 
> But this is a bit strange, because the user can't specify it wants
> a thread-specific signal to the main thread, its tid == pid.

Ah, indeed. I'll make a patch for F_SETOWN_TID then, unless someone
comes up with a better name for the creature ;-)

