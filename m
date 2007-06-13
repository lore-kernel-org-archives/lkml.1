Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbXFMJU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbXFMJU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 05:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbXFMJUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 05:20:53 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:38073 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbXFMJUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 05:20:52 -0400
Message-ID: <466FB6E8.8020606@free.fr>
Date: Wed, 13 Jun 2007 11:20:40 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Runaway process and oom-killer
References: <466FAF99.3070708@free.fr> <20070613090837.GD7443@v2.random>
In-Reply-To: <20070613090837.GD7443@v2.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:

> On Wed, Jun 13, 2007 at 10:49:29AM +0200, John Sigler wrote:
>
>> Question 2: how can I tell which process or kernel thread was hogging 
>> most of the RAM when the oom-killer kicked in?
> 
> Theoretically the one that was killed first but not for sure in
> current mainline hence see below.

If I read the logs correctly, oom-killer is "invoked" three times before 
it effectively kills a process. Then oom-killer kills myapp, syslogd, 
and boa, in that order. Why didn't oom-killer kill anything the first 
three times?

>> Question 3: if myapp was hogging the RAM, then why did oom-killer snipe 
>> other processes (syslogd and boa) after it killed myapp?
> 
> Please try again after applying this monolith (proper submission was
> on linux-mm but the monolith is easier to apply for tests like this):
> 
>    http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.22-rc4/oom-fixes-1

Would this patch apply to a 2.6.20.7-rt8 source tree?

Regards.
