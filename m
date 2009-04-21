Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbZDUKHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbZDUKHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZDUKH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:07:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37334 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbZDUKH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:07:28 -0400
Date: Tue, 21 Apr 2009 12:07:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/filters: disallow newline as delimeter
Message-ID: <20090421100722.GA18486@elte.hu>
References: <49ED8DD2.2070700@cn.fujitsu.com> <49ED8DFD.9070909@cn.fujitsu.com> <20090421095705.GA15448@elte.hu> <49ED9AC2.9000507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ED9AC2.9000507@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> >> I guess because user input is often ended with '\n' (like "echo 
> >> xxx"), thus '\n' is used as a delimeter besides ' ', but we can 
> >> just strip tailing spaces.
> > 
> > Hm, how about:
> > 
> > ( echo 'x'
> >   echo '|| y' ) > filter
> > 
> > type of scripts? Shouldnt the parser be permissive in general?
> > 
> 
> This patch doesn't forbid this usage: ;)
> 
> ( echo 'parent_comm == a'
>   echo '|| parent_comm == b' ) > filter
> 
> This patch does forbid this usage:
> 
> ( echo 'parent_comm'
>   echo '=='
>   echo 'a' ) > filter

Same argument though, no?

	Ingo
