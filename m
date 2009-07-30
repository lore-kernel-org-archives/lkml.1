Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbZG3UcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbZG3UcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZG3UcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:32:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36435 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZG3UcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:32:07 -0400
Date: Thu, 30 Jul 2009 22:28:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
Subject: Re: perf_counters issue with self-sampling threads
Message-ID: <20090730202804.GA13675@redhat.com>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com> <1248869948.6987.3083.camel@twins> <20090729221703.GA25368@redhat.com> <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248984003.4164.0.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Peter Zijlstra wrote:
>
> I'll make a patch for F_SETOWN_TID then, unless someone
> comes up with a better name for the creature ;-)

I think you are right. It is not safe to change the current
behaviour.

Oleg.

