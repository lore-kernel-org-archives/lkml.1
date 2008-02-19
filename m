Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbYBSRd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbYBSRd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYBSRds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:33:48 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:64446 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYBSRds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:33:48 -0500
Message-ID: <47BB12FA.5050604@ct.jp.nec.com>
Date: Tue, 19 Feb 2008 09:33:46 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] latencytop: fix kernel panic and memory leak on proc
References: <47B4C5E7.5000802@ct.jp.nec.com> <20080214164216.45ebf51f@laptopd505.fenrus.org> <20080215011341.GA11756@elte.hu>
In-Reply-To: <20080215011341.GA11756@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Arjan van de Ven <arjan@linux.intel.com> wrote:
> 
>> On Thu, 14 Feb 2008 14:51:19 -0800
>> Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
>>
>>> Hi,
>>>
>>> I posted 2 patches to fix kernel panic and memory leak.
>>> http://lkml.org/lkml/2008/2/14/282
>>> http://lkml.org/lkml/2008/2/14/283
>>>
>>> But, I think this patch is better than old ones.
> 
> thanks Hiroshi, applied.

Hi Ingo,

I'd like to be applied new patch for latencytop fix.
I think it better than old ptaches.

Can you apply this patch for latencytop issues?
http://lkml.org/lkml/2008/2/14/451

It's replacement of old patches you applied.
It makes latency file behavior same as other proc files.
get_proc_task() and put_task_struct() are called at read time,
and returns -ESRCH if get_proc_task() failed.

If is there any problem, please let me know.

thanks,
Hiroshi Shimamoto
