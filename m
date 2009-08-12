Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbZHLIdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbZHLIdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZHLIdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:33:13 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:39576 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZHLIdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:33:12 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf_counters issue with PERF_SAMPLE_GROUP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <7c86c4470908111408x256e294i13ac90035fd8f5c8@mail.gmail.com>
References: <7c86c4470908110841wca07382gf7487c0ed55909f2@mail.gmail.com>
	 <1250006744.10001.29.camel@twins>
	 <7c86c4470908111240s58385748wdb3c3e4a0d66a1ea@mail.gmail.com>
	 <1250024143.7091.7.camel@laptop>
	 <7c86c4470908111408x256e294i13ac90035fd8f5c8@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 10:32:43 +0200
Message-Id: <1250065963.10001.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 23:08 +0200, stephane eranian wrote:

> > Not really, Paul did it like that initially and we've been consistently
> > doing it like that -- changing it now is a bit late.
> >
> 
> But aren't you going to change the cpu, pid target stuff we discussed a couple
> of weeks ago anyway?

Right, I'd like to, but Ingo doesn't. I haven't heard back from Paul on
this.

If we're going to do that we might as well fold these two FORMAT bits
into one or something.



