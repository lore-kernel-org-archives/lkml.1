Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbZINPNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbZINPNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZINPNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:13:46 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:60138 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbZINPNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:13:46 -0400
Message-ID: <4AAE5D60.2080703@nortel.com>
Date: Mon, 14 Sep 2009 09:12:32 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: pavel@pavlinux.ru, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: INGO Why you remove  set_user_nice() from kernel/kthread.c
References: <200909141742.45487.pavel@pavlinux.ru> <1252937140.6500.11.camel@marge.simson.net>
In-Reply-To: <1252937140.6500.11.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Sep 2009 15:13:42.0748 (UTC) FILETIME=[F24EB9C0:01CA354D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2009 08:05 AM, Mike Galbraith wrote:
> If you're asking Ingo a question, maybe a CC is in order.
> 
> On Mon, 2009-09-14 at 17:42 +0400, Pavel Vasilyev wrote:
>>
>> Next patсh -  
>> http://www.kernel.org/diff/diffview.cgi?file=%2Fpub%2Flinux%2Fkernel%2F%2Fv2.6%2Fsnapshots%2Fpatch-2.6.31-git2.bz2;z=548
>>
>> This patch defines the core processes that are working with nice leve equal to 
>> zero , as in the BFS. :)
>>
>> Why?
> 
> I did that, not Ingo, and did so because with kthreads that use
> diddly-spit CPU (every one I see), it's just a waste of math.  What
> kthreads are you seeing using so much CPU that their weight is a factor?
> They _should_ be able to preempt and get their work done just fine
> without a boost.

Under heavy network load ksoftirqd can use significant amounts of cpu.

Chris
