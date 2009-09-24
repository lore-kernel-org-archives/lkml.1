Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZIXTjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZIXTjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZIXTjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:39:32 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:6821 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbZIXTjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:39:31 -0400
Message-ID: <4ABBCACE.90506@caviumnetworks.com>
Date: Thu, 24 Sep 2009 12:38:54 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alexander Huemer <alexander.huemer@sbg.ac.at>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
References: <4ABBB8C2.2080901@sbg.ac.at> <4ABBBB01.1050600@caviumnetworks.com> <4ABBC54E.6090209@sbg.ac.at>
In-Reply-To: <4ABBC54E.6090209@sbg.ac.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2009 19:38:54.0993 (UTC) FILETIME=[A6E02010:01CA3D4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Huemer wrote:
> David Daney wrote:
>> Alexander Huemer wrote:
>>> the problem appears under heavy system load and slows down the system to
>>> unusable speed.
>>> kernels before .30 were not affected.
>>> irqpoll does not change behavior.
>>>
>>> error message from .31:
>>>
>>>     [157152.418524] irq 23: nobody cared (try booting with the "irqpoll"
>>>     option)
>>>     [157152.418530] Pid: 1359, comm: cc1plus Tainted: G        W 
>> Right here is the problem  ->         ^^^^^^^^
>>
>> Haven't you read all the threads about the evil of C++.  This is just
>> one more example of the why we shouldn't be using it. :-)
>>
>> David Daney
>>
[...]
> thanks for your quick answer, david.
> so, this isn't a kernel issue at all ?
> imho a user process shouldn't be able to cause such a situation.
> what can i do against that phenomenon ?
> 

Just for avoidance of doubt, it was an attempt at a joke.

You are of course correct.  It looks like a real bug.  User-space 
shouldn't matter.

David Daney
