Return-Path: <linux-kernel-owner+w=401wt.eu-S1761803AbZFKA7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761803AbZFKA7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 20:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758157AbZFKA7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 20:59:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39674 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbZFKA7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 20:59:00 -0400
Message-ID: <4A3055B3.4070202@zytor.com>
Date: Wed, 10 Jun 2009 17:54:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/3] ring-buffer: add design document
References: <20090610195311.767699959@goodmis.org>	 <20090610195525.429316815@goodmis.org> <1244681467.8361.654.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1244681467.8361.654.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> 
> As far as I know, some architectures have no hardware assisted (NMI
> safe) cmpxchg. Is it OK to use cmpxchg in architecture-independent code?
> 

Including the i386.

	-hpa
