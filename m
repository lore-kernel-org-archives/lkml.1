Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbZL3J2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbZL3J2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZL3J2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:28:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54914 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbZL3J2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:28:47 -0500
Date: Wed, 30 Dec 2009 10:28:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] perf_event: introduce 'inject' event and get HZ
Message-ID: <20091230092830.GA18190@elte.hu>
References: <4B27702F.1080507@cn.fujitsu.com>
 <20091215142325.GC5833@nowhere>
 <4B30C2D1.4030006@cn.fujitsu.com>
 <4B30C3A0.909@cn.fujitsu.com>
 <20091228075417.GB20039@elte.hu>
 <4B3991C1.6060303@cn.fujitsu.com>
 <1262164786.7135.166.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262164786.7135.166.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-12-29 at 13:21 +0800, Xiao Guangrong wrote:
> > 'inject' event is a very useful feature and it's suggested by Ingo
> > [ See http://lkml.org/lkml/2009/12/28/31 ]
> 
> I really dislike the name, event injection to me would be like a write() 
> interface where you provide the actual event data to be stuffed in the 
> output stream.
> 
> This just seems like a very weird way of getting data out. A kind of like 
> sysconf() but done very strange.

What kind of API would you suggest?

	Ingo
