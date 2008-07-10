Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbYGJNEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbYGJNEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYGJNEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:04:35 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:11896 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYGJNEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:04:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qu+Br5dxjQ+PEyYulCDX7vjthKzdIJ3uRRsRR/tq2ogt7sJqXijEyotgNOTzakejBU
         mk++i3bDmXx4sXLedWy1yJafVUz9XVkc53QVJ/cXUvPobyhFFZ3fh8Rsyy7+CMoWivG+
         ov4qsRZQRAJG47kkRUpD7PLzCIwuQgJT3tjbE=
Message-ID: <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
Date: Thu, 10 Jul 2008 15:04:34 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
	 <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 2:50 PM, Dmitry Adamushko
<dmitry.adamushko@gmail.com> wrote:
> 2008/7/10 Vegard Nossum <vegard.nossum@gmail.com>:
>> On Thu, Jul 10, 2008 at 1:59 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>> Hi,
>>>
>>> Looks like CPU hotplug still has some problems. Just got this on
>>> latest mainline, and I couldn't find the exact same report on LKML
>>> or kerneloops, maybe it can be helpful for debugging the existing
>>> problem(s)?
>>>

[...]

> Does a patch from Miao Xie available via the link below makes this
> problem disappear? Both bugs are likely to have the same cause.
>
> http://lkml.org/lkml/2008/7/7/75

Yep, it does, nice, thanks!

Will these two patches (yours and Miao Xie's) be queued for 2.6.26 already?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
