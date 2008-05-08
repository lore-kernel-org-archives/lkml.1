Return-Path: <linux-kernel-owner+w=401wt.eu-S1761067AbYEHJpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067AbYEHJpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbYEHJo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:44:59 -0400
Received: from sacred.ru ([62.205.161.221]:45334 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbYEHJo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:44:59 -0400
Message-ID: <4822CAA5.9020401@openvz.org>
Date: Thu, 08 May 2008 13:40:53 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Mark res_counter_charge(_locked) with __must_check
References: <4822C268.7060501@openvz.org> <20080508184038.f3f2af47.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080508184038.f3f2af47.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 08 May 2008 13:43:34 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 08 May 2008 13:05:44 +0400
> Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>> Ignoring theirs return value may result in counter underflow
>> in the future - when the value charged will be uncharged (or in
>> "leaks" - when the value is not uncharged).
>>
>> This also prevents from using charging routines to decrement the
>> counter value (i.e. uncharge it) ;)
>>
>> (Current code works OK with res_counter, however :) )
>>
>> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>>
> nice check :)

Thanks!

> BTW, res_counter_charge_locked() should be extern function ?

What do you mean? It is extern as well as the res_counter_charge
and uncharge ones are, but functions may have forward declarations
w/o extern keyword AFAIK ;)

> Thanks,
> -Kame
> 
> 

