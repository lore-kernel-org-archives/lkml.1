Return-Path: <linux-kernel-owner+w=401wt.eu-S933283AbXGZOHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283AbXGZOHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbXGZOHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:07:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbXGZOHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:07:07 -0400
Date: Thu, 26 Jul 2007 16:07:02 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       k-miyoshi@cb.jp.nec.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070726140702.GA8949@suse.de>
Mail-Followup-To: Takenori Nagano <t-nagano@ah.jp.nec.com>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	k-miyoshi@cb.jp.nec.com, Andrew Morton <akpm@linux-foundation.org>
References: <469F55D0.4050203@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F55D0.4050203@ah.jp.nec.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Takenori Nagano <t-nagano@ah.jp.nec.com> [2007-07-19 14:15]:
> 
> In latest kernel, we can't use panic_notifier_list if kdump is enabled.
> panic_notifier_list is very useful function for debug, failover, etc...
> 
> So this patch adds a control file /proc/sys/kernel/dump_after_notifier
> and resolves a problem users can not use both kdump and panic_notifier_list
> at the same time.
> 
> kdump_after_notifier = 0
>  -> panic()
>     -> crash_kexec(NULL)
> 
> kdump_after_notifier = 1
>  -> panic()
>     -> atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
>     -> crash_kexec(NULL)

What's problematic about this patch? I also would like to see that
feature.


Thanks,
   Bernhard
