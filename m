Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbYFUKOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbYFUKOp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 06:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYFUKOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 06:14:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42378 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYFUKOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 06:14:34 -0400
Date: Sat, 21 Jun 2008 19:12:59 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC][Patch 2/2] markers: example of irq regular kernel markers
Cc: kosaki.motohiro@jp.fujitsu.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
In-Reply-To: <485C064E.5020705@redhat.com>
References: <20080620174529.GB10943@Krystal> <485C064E.5020705@redhat.com>
Message-Id: <20080621190132.E835.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > By doing so, we could leave a gcc format string check by passing the
> > format string to __mark_check_format(). We could extract the field names
> > from the prototype, so there is no need to duplicate field information
> > in the format string.
> 
> I thought that someone complained against those format strings in
> kernel code. Thus I removed it from DEFINE_TRACE.
> 
> even though, I think you can do that by adding below string table
> to LTTng module.
> 
> const char *lookup_table[MAX_MARKERS][2] = {
> {"irq_entry", "%d %d"}, // or "(int irq_id, int kernel_mode)", "%d %d"
> ...
> };

if move string to out of kernel core, compiler may kill some variable.
thus, we will get incomplete tracing result.

I think your proposal is very interesting.
but I dont understand why someone dislike format strings.
Could you explain this reason?


