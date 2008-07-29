Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYG2B0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYG2B0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYG2B0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:26:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58333 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbYG2B0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:26:43 -0400
Message-ID: <488E7172.30104@cn.fujitsu.com>
Date: Tue, 29 Jul 2008 09:25:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>
CC: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cpuset: clean up cpuset hierarchy traversal code
References: <488D332A.1030008@cn.fujitsu.com> <20080728010141.fbd33866.pj@sgi.com> <488DFFD2.7070004@qualcomm.com>
In-Reply-To: <488DFFD2.7070004@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Paul, please take a look at
>     cpuset: Rework sched domains and CPU hotplug handling
> patch I sent out last week.
> I'd appreciate if we applied that one first. It simplifies lock nesting
> and rearranges the way sched domains are rebuilt. It is IMO a bit higher
> priority than this patch because scheduler depends on the
> rebuild_sched_domains() call and we have to call rebuild_sched_domains()
> from cpu hotplug handlers.
> 

I don't mind which one gets first. :)

