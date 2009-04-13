Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZDMD50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZDMD50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 23:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZDMD5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 23:57:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbZDMD5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 23:57:16 -0400
Date: Mon, 13 Apr 2009 05:57:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 1/1] tracing, workqueuetrace: Make workqueue
	tracepoints use TRACE_EVENT macro
Message-ID: <20090413035700.GE11652@elte.hu>
References: <49E28D4B.5040802@cn.fujitsu.com> <20090413103639.6DF4.A69D9226@jp.fujitsu.com> <20090413122350.6DFE.A69D9226@jp.fujitsu.com> <49E2B656.1020308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E2B656.1020308@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> It it because I use similar format with other TRACE_EVENT 
> definition. Actually, I don't know why we need to add prefix and 
> postfix TABs, and is it necessary to use tab to make alignment for 
> each fields.

The __array() entry is a bit special - i wouldnt worry much about 
it, please ignore the checkpatch warning in this case - or remove 
the prefix tab.

The alignment of the fields are useful visually: all the field names 
are enumerated in a vertical row and are easy to see at a glance. 
The postfix tabs are nice because they move the non-C-syntax closing 
')' out of the line of sight. The prefix tabs are useful for a 
similar reason.

	Ingo
