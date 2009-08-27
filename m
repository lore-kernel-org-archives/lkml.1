Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbZH0O4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbZH0O4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZH0O4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:56:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58722 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZH0O4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:56:19 -0400
Date: Thu, 27 Aug 2009 10:56:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
In-Reply-To: <20090827143902.GA3552@Krystal>
Message-ID: <alpine.DEB.2.00.0908271052370.27674@gandalf.stny.rr.com>
References: <1251270092.7538.1226.camel@twins> <4A94DFF4.5030301@cn.fujitsu.com> <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com> <20090826164624.GA21456@Krystal> <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com> <20090826180114.GA29130@Krystal>
 <20090826181758.GA30248@Krystal> <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com> <4A95E737.5080805@cn.fujitsu.com> <alpine.DEB.2.00.0908262209460.18923@gandalf.stny.rr.com> <20090827143902.GA3552@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Aug 2009, Mathieu Desnoyers wrote:

> Looks good. Just don't forget to eventually add the "synchronize" calls
> between tracepoint unregistration and the removal of their module. There
> is a race condition in the way you do it currently.

I'm trying to figure out the race here. What will disappear in the 
tracepoint? Could you give a brief example of the issue.

Thanks,

-- Steve


