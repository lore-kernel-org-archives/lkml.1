Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbZEQIOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbZEQIOF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 04:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZEQINq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 04:13:46 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:58371 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZEQINo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 04:13:44 -0400
Message-ID: <4A0FC736.7050301@in.ibm.com>
Date: Sun, 17 May 2009 13:43:42 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [Bug #13068] Lockdep warining in inotify_dev_queue_event
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.UHD.QazDKB@chimera> <20090517063530.GB1583@elte.hu>
In-Reply-To: <20090517063530.GB1583@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i think this might be fixed by:
>
> 381a80e: inotify: use GFP_NOFS in kernel_event() to work around a lockdep false-positive
>
> already in -rc6.
>   
Haven't seen this issue with rc6.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

