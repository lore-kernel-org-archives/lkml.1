Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbXKWIF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbXKWIF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 03:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbXKWIFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 03:05:49 -0500
Received: from sacred.ru ([62.205.161.221]:48510 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbXKWIFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 03:05:48 -0500
Message-ID: <47468927.3040304@openvz.org>
Date: Fri, 23 Nov 2007 11:02:47 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>,
       Pierre Peiffer <pierre.peiffer@bull.net>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [PATCH 2.6.24-rc3-mm1] IPC: make struct ipc_ids static in ipc_namespace
References: <20071122155448.3193c856.pierre.peiffer@bull.net> <474680B5.7020104@fr.ibm.com> <47468347.5090303@openvz.org>
In-Reply-To: <47468347.5090303@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 23 Nov 2007 11:02:52 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> Cedric Le Goater wrote:
>> Pierre Peiffer wrote:

[snip]

>> Pavel, what do you think of it ? 
> 
> Looks sane, good catch, Pierre.
> 
> But I'd find out whether these three ipc_ids intersect any 
> cache-line. In other words I'd mark the struct ipc_ids as
> ____cacheline_aligned and checked for any differences.

BTW! It might be also useful to keep ipc_ids closer to their
sysctl parameters.

>> Acked-by: Cedric Le Goater <clg@fr.ibm.com>
>>
>> Thanks,
> 
> Thanks,
> Pavel
> 
>> C.

[snip]
