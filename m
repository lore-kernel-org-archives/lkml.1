Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYBQIik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYBQIik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYBQIia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:38:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:30311 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbYBQIi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:38:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=HY3kXuVBUiI8bvfdYYYSfunaiA138jpNWwLdBf9MnaKEv6EzoCK2JXIn4d7elAEQpG6KTx2+e1KpdD5WhYsNcoywWfti+ZhRAj5Y2AsLB7o9gaXfyLM/icCLMp3bS73ANYZHtoSxI9Y/Yj7Svj5BteNVP5KxZLP4I8MCEQXQgxU=
Date: Sun, 17 Feb 2008 11:38:01 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: trivial sparse warning in sched.c
Message-ID: <20080217083801.GA6752@cvg>
References: <1203098196.15275.5.camel@brick> <1203196289.6301.20.camel@lappy> <20080216212747.GC6753@cvg> <1203198314.6298.6.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203198314.6298.6.camel@lappy>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Peter Zijlstra - Sat, Feb 16, 2008 at 10:45:14PM +0100]
| 
| On Sun, 2008-02-17 at 00:27 +0300, Cyrill Gorcunov wrote:
| > [Peter Zijlstra - Sat, Feb 16, 2008 at 10:11:29PM +0100]
| > | 
[...]
| > 
| > Hi Peter,
| > 
| > dont you find 'return (void)foo();' statement a bit strange (as it was in
| > original code)? ;) Am I wrong? /it's night here, so half a brain already
| > tuned off ;)/
| 
| void foo(void);
| 
| void bar(void)
| {
| 	return foo();
| }
| 
| Maybe I'm just weird an twisted, but no, I don't find it odd. In my mind
| its consistent with how all other return types function.
| 
| Not sure what the C std text says on the matter though.
| 
| 

well, i've an obscure feeling about that. From one side I do understand that
you're *absolutely right* but the second form of statement is more clear
methink. That is what I prefer personally. Anyway the form of writting
such a statement is taste of code author - so you choose ;)

		- Cyrill -
