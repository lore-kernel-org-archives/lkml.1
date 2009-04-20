Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZDTHMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZDTHMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbZDTHMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:12:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47840 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZDTHMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:12:43 -0400
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
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
From: Andi Kleen <andi@firstfloor.org>
References: <20090414172337.280621613@goodmis.org>
	<20090414172640.796858018@goodmis.org> <49E51FC1.8090306@goop.org>
	<20090415014548.GA7984@Krystal> <49E6065B.7080409@goop.org>
	<20090416023456.GC22378@Krystal> <49E69E76.9030608@goop.org>
	<20090416234410.GA20513@Krystal>
Date: Mon, 20 Apr 2009 09:12:35 +0200
In-Reply-To: <20090416234410.GA20513@Krystal> (Mathieu Desnoyers's message of "Thu, 16 Apr 2009 19:44:11 -0400")
Message-ID: <87zlebpzmk.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:

> Given how slow function calls are, at least on x86,

That was with frame pointers right? Frame pointers tend to make
function calls slow.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
