Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZKTIr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZKTIr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZKTIr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:47:28 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56220 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZKTIr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:47:27 -0500
Message-ID: <4B0657A4.2040606@cs.helsinki.fi>
Date: Fri, 20 Nov 2009 10:47:32 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 1/2] perf: Add 'perf kmem' tool
References: <4B064AF5.9060208@cn.fujitsu.com> <20091120081440.GA19778@elte.hu> <84144f020911200019p4978c8e8tc593334d974ee5ff@mail.gmail.com> <20091120083053.GB19778@elte.hu>
In-Reply-To: <20091120083053.GB19778@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar kirjoitti:
> Regarding patch 2 - can we set some definitive benchmark threshold for 
> that? I.e. a list of must-have features in 'perf kmem' before we can do 
> it? 100% information and analysis equivalency with kmemtrace-user tool? 

I'd be interested to hear Eduard's comment on that.

That said, I'll try to find some time to test "perf kmem" and provide 
feedback on that. I can ACK the patch when I'm happy with the output. :-)

I'm mostly interested in two scenarios: (1) getting a nice report on 
worst fragmented call-sites (perf kmem needs symbol lookup) and (2) 
doing "perf kmem record" on machine A (think embedded here) and then 
"perf kmem report" on machine B. I haven't tried kmemtrace-user for a 
while but it did support both of them quite nicely at some point.

			Pekka
