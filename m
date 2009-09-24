Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbZIXNOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbZIXNOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZIXNOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:14:07 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:46119 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZIXNOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:14:05 -0400
Message-ID: <4ABB708F.1080308@gmail.com>
Date: Thu, 24 Sep 2009 15:13:51 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_?= =?ISO-8859-1?Q?Weisbecker?= 
	<fweisbec@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf tools: fix buffer allocation
References: <4ABB6EB7.7000002@gmail.com> <20090924131250.GA15132@elte.hu>
In-Reply-To: <20090924131250.GA15132@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 24 Sep 2009 15:13:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
>> Hi Ingo
>>
>> Here is a patch for perf.
> 
> Applied, thanks Eric!
> 
>> BTW, use of openat() is a nuisance, since many machines have old glibc
>> (RHEL 4 Update 5 -> glibc-2.3.4-2.36 on my dev machine for example)
> 
> We can certainly remove that reliance - wanna send a patch for it?

Yes I'll do it, thanks.
