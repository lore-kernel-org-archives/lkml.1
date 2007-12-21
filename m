Return-Path: <linux-kernel-owner+w=401wt.eu-S1762826AbXLUNqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762826AbXLUNqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 08:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbXLUNqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 08:46:35 -0500
Received: from mail.windriver.com ([147.11.1.11]:42573 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbXLUNqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:46:34 -0500
Message-ID: <476BC3B0.6020902@windriver.com>
Date: Fri, 21 Dec 2007 07:46:24 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>	<476A9E97.4040105@windriver.com> <20071220151103.a873e22d.akpm@linux-foundation.org>
In-Reply-To: <20071220151103.a873e22d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Dec 2007 13:46:24.0868 (UTC) FILETIME=[E0CDEA40:01C843D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 20 Dec 2007 10:55:51 -0600
> Jason Wessel <jason.wessel@windriver.com> wrote:
>
>   
>> Andrew Morton wrote:
>>     
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/
>>>
>>> - git-kgdb.patch is still dropped for the same reason
>>>
>>>  
[snip]  Regarding the merge output targeting -mm
> Conflicts with the arm, ia64, mips, sh and driver trees (at least).  I
> fixed most of them but gave up on sh, where there has been major code
> motion.
>
>   

Andrew,

Given the churn in patches I think the best approach is to put kgdb
after you have cut a -mm1 so it can go in -mm2 or as a fix or however
you would like to manage it.  The churn should be a whole lot less once
the new kgdb arch support gets merged.

I updated the for_mm branch to be against 2.6.24-rc5-mm1, and it will
merge cleanly.  I can update again once the next mm branch is available.


Thanks,
Jason.
