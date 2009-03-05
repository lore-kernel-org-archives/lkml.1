Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbZCEXrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbZCEXrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbZCEXrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:47:08 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:38923 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424AbZCEXrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:47:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAFPyr0lMQW1W/2dsb2JhbACBTtZihAgG
Date: Thu, 5 Mar 2009 18:47:00 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Subject: Re: [RFC patch 29/41] LTTng menus
Message-ID: <20090305234700.GA17212@Krystal>
References: <20090305224728.947235917@polymtl.ca> <20090305225518.148142886@polymtl.ca> <49B061DA.1010908@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49B061DA.1010908@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:45:35 up 5 days, 20:11,  2 users,  load average: 0.76, 0.90,
	1.89
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> Mathieu Desnoyers wrote:
> 
> <<attachment :(>>
> 
> 
> +menuconfig LTT
> +	bool "Linux Trace Toolkit Next Generation (LTTng)"
> +	depends on EXPERIMENTAL
> +	select MARKERS
> +	select TRACEPOINTS
> +	default y
> 
> Not default 'y', please.
> 

OK, so default n it is. But I plan to leave the main menu "sub-features" as
default y, given that people get the standard features when they choose
to enable the tracer. Hopefully this is ok ?

Mathieu

> -- 
> ~Randy

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
