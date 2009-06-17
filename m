Return-Path: <linux-kernel-owner+w=401wt.eu-S1764733AbZFQMQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764733AbZFQMQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758801AbZFQMQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:16:19 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:41530 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbZFQMQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:16:19 -0400
Message-ID: <4A38DE90.4020500@in.ibm.com>
Date: Wed, 17 Jun 2009 17:46:16 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       menage@google.com, Balbir Singh <balbir@linux.vnet.ibm.com>,
       abogani@texware.it, Al Viro <viro@zeniv.linux.org.uk>,
       chrisw@sous-sol.org
Subject: Re: [BUG] lib/kernel_lock.c:126 with cgroups regression ltp tests
References: <4A38CAAC.4090606@in.ibm.com> <1245237613.4269.13.camel@concordia>
In-Reply-To: <1245237613.4269.13.camel@concordia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman wrote:
> On Wed, 2009-06-17 at 16:21 +0530, Sachin Sant wrote:
>   
>> While executing cgroups regression tests from LTP May 2009
>> release on a Power6 box came across the following bug.
>>     
>
>   
>> This is with 2.6.30-git10 (300df7dc89cc276377fc020704e34875d5c473b6)
>>     
>
> Looks like 337eb00a2 missed some return paths in do_remount_sb()?
>
> $ git log -p -U13 337eb00a2c3a421999c39c94ce7e33545ee8baa7 fs/super.c
> commit 337eb00a2c3a421999c39c94ce7e33545ee8baa7
> Author: Alessio Igor Bogani <abogani@texware.it>
Thanks Michael.

The following submitted patch from Chris fixes this issue.

http://patchwork.kernel.org/patch/30675/

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

