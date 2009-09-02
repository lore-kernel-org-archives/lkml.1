Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZIBDM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZIBDM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 23:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755658AbZIBDM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 23:12:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54358 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755620AbZIBDMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 23:12:55 -0400
Message-ID: <4A9DE293.6050703@cn.fujitsu.com>
Date: Wed, 02 Sep 2009 11:12:19 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rostedt@goodmis.org, mingo@elte.hu, nhorman@tuxdriver.com,
       fweisbec@gmail.com, yjwei@cn.fujitsu.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] tracing/events: convert NAPI's tracepoint via
 TRACE_EVENT
References: <4A9B6AA7.5020508@cn.fujitsu.com>	<20090831084922.GB25811@elte.hu>	<alpine.DEB.2.00.0908311407060.13931@gandalf.stny.rr.com> <20090901.182645.153420711.davem@davemloft.net>
In-Reply-To: <20090901.182645.153420711.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



David Miller wrote:

> This patch can't be split up, so I'm wondering how you suggest to
> handle this patch given that you have declared that define_trace.h
> changes aren't to go through the subsystem tree?
> 
> If we do the define_trace.h change only, we break the build
> (lack of macro defined for the trace).
> 
> If we do only the other parts of his patch, we get a duplicate
> definition.
> 

This patch cooperate with my previous patch to solve the include file
dependencies problem. So, we do better put those two patches together.
(both in -tip tree or/add both in network tree)

The previous patch is below:

Commit-ID:  5ac35daa9343936038a3c9c4f4d6d3fe6a2a7bd8
Gitweb:     http://git.kernel.org/tip/5ac35daa9343936038a3c9c4f4d6d3fe6a2a7bd8
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Tue, 25 Aug 2009 14:06:22 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 26 Aug 2009 00:32:09 -0400

tracing/events: fix the include file dependencies

> And keep in mind that Neil and Xiao are probably going to want to do
> work on top of this to the networking bits.  Thus if we put this patch
> here into the tracing tree, I'll have to develop a dependency on the
> tracing tree and I think that will go over like a fart in a spacesuit
> with the -next crowd and Stephen Rothwell in particular.
> 

Thank you, David

Xiao
