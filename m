Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZHCJcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZHCJcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbZHCJcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:32:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56947 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbZHCJcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:32:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3] Add walltime support for ring-buffer
Cc: kosaki.motohiro@jp.fujitsu.com, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090803072255.GB27581@elte.hu>
References: <20090728105931.D801.A69D9226@jp.fujitsu.com> <20090803072255.GB27581@elte.hu>
Message-Id: <20090803182412.CC15.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  3 Aug 2009 18:32:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > It can. but I don't think it is sufficient. On flight recorder 
> > use-case, The tracing run more than one year. And, Administrator 
> > only see last N sec log. (previous logs were overwritten by 
> > ring-buffer go-around)
> 
> That's definitely something we want to enable ASAP.
> 
> I'm wondering why a single u64 timestamp is not enough to express 
> the full, absolute range of time elapsed since bootup, in 
> nanoseconds.
> 
> That would make walltime a matter of pretty-printing only - we'd 
> have to convert the u64 nsec timestamp into a walltime format, 
> right?
> 
> In fact we could change all the timestamps to be standardized along 
> 'nanoseconds elapsed since 1970' or so - not nanoseconds since the 
> last bootup. That still fits just fine within 64 bits - u64 
> nanoseconds has a scope of 500+ years.

Ah, you are right. thanks correct me.
but I think ntp updating time storing is necessary too.



