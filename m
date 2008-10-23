Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYJWRFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYJWRFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYJWRFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:05:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46380 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753159AbYJWRF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:05:29 -0400
Message-ID: <4900AF14.8010409@sgi.com>
Date: Thu, 23 Oct 2008 10:06:28 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug #2] Re: [PATCH 00/35] cpumask: Replace cpumask_t with	struct
 cpumask
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023125529.GA18327@elte.hu> <20081023142025.GA18804@elte.hu> <200810240201.15037.rusty@rustcorp.com.au> <20081023160610.GA8853@elte.hu> <4900A3C6.1080000@sgi.com> <20081023163508.GA15921@elte.hu> <4900AB49.9040404@sgi.com> <20081023165218.GA25697@elte.hu>
In-Reply-To: <20081023165218.GA25697@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> git-checkout -b cpus4096-v2 tip/cpus4096-v2
>> git checkout: updating paths is incompatible with switching branches/forcing
>> Did you intend to checkout 'tip/cpus4906-v2' which can not be resolved as commit?
> 
> see the typo in the error message?
> 
>> or:
>>
>> git-checkout tip/cpus4906-v2
>> error: pathspec 'tip/cpus4906-v2' did not match any file(s) known to git.
>> Did you forget to 'git add'?
> 
> the 4906/4096 typo in shown in this error message as well.
> 
> 	Ingo

Sorry, that was a cut and paste error in this example.  I've tried both these
.git/config's and both hang during bootup:


[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "linus"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
        fetch = +refs/heads/*:refs/remotes/linus/*
[remote "tip"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
        fetch = +refs/heads/*:refs/remotes/tip/*
[branch "cpus4096-v2"]
        remote = tip
        merge = refs/heads/cpus4096-v2


[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "linus"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
        fetch = +refs/heads/*:refs/remotes/linus/*
[remote "tip"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
        fetch = +refs/heads/*:refs/remotes/tip/*
[branch "tip-latest"]
        remote = tip
        merge = refs/heads/master
[branch "cpus4096-v2"]
        remote = tip
        merge = refs/heads/cpus4096-v2
