Return-Path: <linux-kernel-owner+w=401wt.eu-S1759919AbXGRJqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbXGRJqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbXGRJqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:46:04 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:62747 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbXGRJqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:46:02 -0400
Date: Wed, 18 Jul 2007 15:11:42 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: System hangs on running kernbench
Message-ID: <20070718094142.GA12330@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20070718075648.GA4235@linux.vnet.ibm.com> <20070718010700.1ca7fd9f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718010700.1ca7fd9f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 01:07:00AM -0700, Andrew Morton wrote:
> On Wed, 18 Jul 2007 13:26:48 +0530 Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> 
> > I was running kernbench on top of 2.6.22-rc6-mm1 and I got a Hangcheck
> > alert (This is when kernbench reached make -j).
> 
> hm, never had a report of that before.  It's the first time I've seen
> hangcheck produce anything useful, frankly.
> 
> Was the softlockup detector not enabled?

I notice CONFIG_DETECT_SOFTLOCKUP=y
> 
> > Also make -j is hanging.
> 
> Please try to capture the full sysrq-T output when it is hung.

Available at http://dhaval.giani.googlepages.com/sysrq-t-trace.bz2

In the meantime I will go and check if it was there in 2.6.22-rc4-mm2

-- 
regards,
Dhaval

I would like to change the world but they don't give me the source code!
