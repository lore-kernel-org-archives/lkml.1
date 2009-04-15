Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbZDOJee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbZDOJee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZDOJeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:34:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:53563 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZDOJeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:34:23 -0400
Subject: Re: [PATCH 2/4] tracing/events: fix lockdep system name
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
In-Reply-To: <20090415031604.933829085@goodmis.org>
References: <20090415031511.128139334@goodmis.org>
	 <20090415031604.933829085@goodmis.org>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 11:32:42 +0200
Message-Id: <1239787962.22720.1966.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 23:15 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0002-tracing-events-fix-lockdep-system-name.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: fix compile error of lockdep event tracer
> 
> Ingo Molnar pointed out that the system name for the lockdep tracer was "lock"
> which is used to include the event trace file name. It should be "lockdep"

Ah, I did that on purpose. Whilst it all stems from the lockdep code,
these tracepoints have nothing much to do with dependency tracking,
hence I decided to drop that bit of the name.



