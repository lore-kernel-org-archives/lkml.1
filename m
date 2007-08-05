Return-Path: <linux-kernel-owner+w=401wt.eu-S1763730AbXHEJkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763730AbXHEJkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 05:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbXHEJkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 05:40:16 -0400
Received: from mailhub.lawrence.edu ([143.44.0.14]:59937 "EHLO lawrence.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751650AbXHEJkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 05:40:15 -0400
Message-ID: <46B59AE2.4000404@gmail.com>
Date: Sun, 05 Aug 2007 05:39:46 -0400
From: Dan Zwell <dzwell@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: tuning CFS: /proc/sys/kernel/sched_granularity_ns question
References: <46B58A69.20708@gmail.com>
In-Reply-To: <46B58A69.20708@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Zwell wrote:
> Hi. I see "/proc/sys/kernel/sched_granularity_ns" mentioned on web sites 
> and such, but I do have this file and cannot create it. Yes, I am root 
> and /proc is mounted. Are there boot parameters that I must enable to 
> tune this variable? Do I need to specifically enable this in .config?
> 

Sorry for the dumb question--I searched the source and found that 
CONFIG_SCHED_DEBUG must be defined, and after enabling kernel debugging, 
this was automatically turned on. I didn't realize that this type of 
tuning was considered debugging.

Thanks,
Dan
