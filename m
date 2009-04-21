Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZDUWWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZDUWWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 18:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZDUWV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 18:21:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59260 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZDUWV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 18:21:57 -0400
Date: Tue, 21 Apr 2009 18:21:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2 v3] tracing/events: provide string with undefined
 size support
In-Reply-To: <20090421221241.GA6744@nowhere>
Message-ID: <alpine.DEB.2.00.0904211820410.9714@gandalf.stny.rr.com>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <1240117295-6873-2-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0904211749580.10097@gandalf.stny.rr.com> <alpine.DEB.2.00.0904211759540.10097@gandalf.stny.rr.com>
 <20090421221241.GA6744@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Apr 2009, Frederic Weisbecker wrote:
> 
> 
> Thanks!
> Then, may be I should wait for Ingo's pull (if he accepts)
> before sending a delta to add the parenthesis around __get_str().

It would probably be better to just make the fix now. Just put the fix in 
a separate branch to avoid race conditions (if Ingo already did a pull ;-)

-- Steve
