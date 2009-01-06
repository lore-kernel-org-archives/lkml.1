Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbZAFKrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbZAFKrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbZAFKrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:47:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48820 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbZAFKrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:47:06 -0500
Message-ID: <496336A4.4020109@redhat.com>
Date: Tue, 06 Jan 2009 11:47:00 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [BUG] INFO: inconsistent lock state
References: <4962C322.8000201@cn.fujitsu.com> <49633005.5080305@redhat.com> <4963319D.8040204@cn.fujitsu.com>
In-Reply-To: <4963319D.8040204@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan napsal(a):
> Zdenek Kabelac wrote:
>> Li Zefan napsal(a):
>>> I am using Linus' tree, and the top commit is:
>>>
>>> commit fe0bdec68b77020281dc814805edfe594ae89e0f
>>> Merge: 099e657... 5af75d8...
>>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>>> Date:   Sun Jan 4 16:32:11 2009 -0800
>>>
>>>     Merge branch 'audit.b61' of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current
>>>
>>> don't know how I triggered this, and not sure whom to CC, network
>>> related?
>>>
>> I've got the similar one too: http://lkml.org/lkml/2009/1/3/55
>>
> 
> So your box freezed and can do nothing but reset ?
> 
> I was much luckier that this bug didn't do any harm to my box. :)

Well the problem was that at the same time it has probably crashed my Xorg 
server (with some recent rawhide version) and this might have been the reason 
of hard crash as well - I'm not sure what was the exact order.

Zdenek

