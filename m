Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbYBPQo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbYBPQo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbYBPQot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:44:49 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:7342 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbYBPQos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:44:48 -0500
X-IronPort-AV: E=Sophos;i="4.25,361,1199685600"; 
   d="scan'208";a="542685593"
Date: Sat, 16 Feb 2008 10:44:34 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Corey Minyard <minyard@acm.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Konstantin Baydarov <kbaidarov@ru.mvista.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: Re: [Openipmi-developer] [PATCH 3/4] IPMI: convert locked counters to atomics
Message-ID: <20080216164434.GC13922@auslistsprd01.us.dell.com>
References: <20080214183051.GC20148@minyard.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214183051.GC20148@minyard.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 12:30:51PM -0600, Corey Minyard wrote:
> From: Konstantin Baydarov <kbaidarov@ru.mvista.com>
> 
> Atomics are a lot more efficient and neat than using a lock.

per_cpu variables are a lot more efficient and neat than using locks
for simple statistics.  no cache line bouncing to increment the
counter.  Are these read so often that atomics are really better?

Thanks,
Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
