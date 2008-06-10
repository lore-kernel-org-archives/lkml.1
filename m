Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbYFJIaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbYFJIaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 04:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYFJIao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 04:30:44 -0400
Received: from as1.cineca.com ([130.186.84.213]:45041 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYFJIan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 04:30:43 -0400
Message-ID: <484E3BA4.3000606@gmail.com>
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>, balbir@linux.vnet.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: menage@google.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [RFC PATCH 0/5] memcg: VM overcommit accounting and handling
References: <1213054383-18137-1-git-send-email-righi.andrea@gmail.com> <20080610091439.04061da9.kamezawa.hiroyu@jp.fujitsu.com> <484E0D73.6010609@linux.vnet.ibm.com> <484E32B9.4020606@openvz.org>
In-Reply-To: <484E32B9.4020606@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Jun 2008 10:30:29 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> Balbir Singh wrote:
>> KAMEZAWA Hiroyuki wrote:
>>> On Tue, 10 Jun 2008 01:32:58 +0200
>>> Andrea Righi <righi.andrea@gmail.com> wrote:
>>>
>>>> Provide distinct cgroup VM overcommit accounting and handling using the memory
>>>> resource controller.
>>>>
>>> Could you explain the benefits of this even when we have memrlimit controller ?
>>> (If unsure, see 2.6.26-rc5-mm1 and search memrlimit controller.)
>>>
>>> And this kind of virtual-address-handling things should be implemented on
>>> memrlimit controller (means not on memory-resource-controller.).
>>> It seems this patch doesn't need to handle page_group.
>>>
>>> Considering hierarchy, putting several kinds of features on one controller is
>>> not good, I think. Balbir, how do you think ?
>>>
>> I would tend to agree. With the memrlimit controller, can't we do this in user
>> space now? Figure out the overcommit value and based on that setup the memrlimit?
> 
> I also agree with Balbir and Kamezawa. Separate controller for VM (i.e. vma-s
> lengths) is more preferable, rather than yet another fancy feature on top of 
> the existing rss one.
> 

Yep! it seems I totally miss the memrlimit controller. I was trying to
implement pretty the same functionalities, using a different approach.
However, I agree that a separate controller seems to be a better
solution.

Thank you all for pointing in the right direction. I'll test memrlimit
controller and give a feedback.

-Andrea
