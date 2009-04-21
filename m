Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZDUP43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZDUP43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZDUP4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:56:19 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:53754 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbZDUP4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:56:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYFAOeJ7UlMQW1W/2dsb2JhbACBT9N+g3oG
Date: Tue, 21 Apr 2009 11:51:07 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka@firstfloor.org
Subject: Re: [PATCH 2/8] tracing: create automated trace defines
Message-ID: <20090421155106.GE3792@Krystal>
References: <20090414172337.280621613@goodmis.org> <20090414172640.796858018@goodmis.org> <49E51FC1.8090306@goop.org> <20090415014548.GA7984@Krystal> <49E6065B.7080409@goop.org> <20090416023456.GC22378@Krystal> <49E69E76.9030608@goop.org> <20090416234410.GA20513@Krystal> <87zlebpzmk.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <87zlebpzmk.fsf@basil.nowhere.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:48:24 up 52 days, 12:14,  2 users,  load average: 3.67, 2.69,
	1.49
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:
> 
> > Given how slow function calls are, at least on x86,
> 
> That was with frame pointers right? Frame pointers tend to make
> function calls slow.
> 

Looking at my .config, CONFIG_FRAME_POINTER is disabled here. So we
should probably expect an even worse performance impact if we enable
them.

Mathieu


> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only.
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
