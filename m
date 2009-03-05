Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbZCEXxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbZCEXxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbZCEXx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:53:28 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:39423 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbZCEXx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:53:27 -0500
Message-ID: <49B0658D.1090706@oracle.com>
Date: Thu, 05 Mar 2009 15:51:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
References: <20090305224728.947235917@polymtl.ca> <20090305225518.148142886@polymtl.ca> <49B061DA.1010908@oracle.com> <20090305234700.GA17212@Krystal>
In-Reply-To: <20090305234700.GA17212@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49B0652F.0148:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
>> Mathieu Desnoyers wrote:
>>
>> <<attachment :(>>
>>
>>
>> +menuconfig LTT
>> +	bool "Linux Trace Toolkit Next Generation (LTTng)"
>> +	depends on EXPERIMENTAL
>> +	select MARKERS
>> +	select TRACEPOINTS
>> +	default y
>>
>> Not default 'y', please.
>>
> 
> OK, so default n it is. But I plan to leave the main menu "sub-features" as
> default y, given that people get the standard features when they choose
> to enable the tracer. Hopefully this is ok ?

Sure, as long as it just enables viewing the menu and not adding
code to a growing kernel.

-- 
~Randy
