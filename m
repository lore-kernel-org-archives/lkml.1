Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbYDYMcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbYDYMcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 08:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYDYMcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 08:32:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34687 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYDYMcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 08:32:07 -0400
Date: Fri, 25 Apr 2008 14:32:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: add statics, don't return void expressions
In-Reply-To: <1209125826.24931.12.camel@lappy>
Message-ID: <alpine.LNX.1.10.0804251431510.6645@fbirervta.pbzchgretzou.qr>
References: <1209086275.20088.4.camel@brick> <1209125826.24931.12.camel@lappy>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-04-25 14:17, Peter Zijlstra wrote:
>On Thu, 2008-04-24 at 18:17 -0700, Harvey Harrison wrote:
>> Noticed by sparse:
>> kernel/sched.c:760:20: warning: symbol 'sched_feat_names' was not declared. Should it be static?
>> kernel/sched.c:767:5: warning: symbol 'sched_feat_open' was not declared. Should it be static?
>> kernel/sched_fair.c:845:3: warning: returning void-valued expression
>> kernel/sched.c:4386:3: warning: returning void-valued expression
>
>I'm still of two minds about that latter warning, I think:
>
>void foo(void);
>
>void bar(void)
>{
>	return foo();
>}
>
>isn't wrong, as the return types match.

But you could save a keyword and use

void bar(void)
{
	foo();
}

