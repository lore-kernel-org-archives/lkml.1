Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbZFLDzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbZFLDzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZFLDzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:55:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33286 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbZFLDzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:55:32 -0400
Message-ID: <4A31CF8C.6060609@zytor.com>
Date: Thu, 11 Jun 2009 20:46:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/3] ring-buffer: add design document
References: <20090610195311.767699959@goodmis.org>	 <20090610195525.429316815@goodmis.org>	 <1244681467.8361.654.camel@yhuang-dev.sh.intel.com>	 <alpine.DEB.2.00.0906102155420.30552@gandalf.stny.rr.com>	 <1244687581.8361.703.camel@yhuang-dev.sh.intel.com>	 <20090611023807.GA12407@Krystal> <1244776417.5320.160.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1244776417.5320.160.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> 
> Yes. It seems that ARM is OK after FIQ save/restore issue is fixed.
> Another machine with NMI but no NMI-safe cmpxchg is "real" 386. That is
> very old machine, does that matter?
> 

Well, we still support it (UP only, though.)  It all depends on if there
is a fallback that is good enough.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

