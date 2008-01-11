Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYAKKrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYAKKrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbYAKKrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:47:16 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:44390 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939AbYAKKrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:47:15 -0500
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jan 2008 05:47:14 EST
X-IronPort-AV: E=Sophos;i="4.24,271,1196636400"; 
   d="scan'208";a="6532234"
Date: Fri, 11 Jan 2008 11:47:13 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, David Dillow <dillowda@ornl.gov>,
       linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
Subject: Re: [patch] block: fix blktrace timestamps
Message-ID: <20080111114713.0a2df9ee@cheypa.inria.fr>
In-Reply-To: <20080111102953.GA27223@elte.hu>
References: <1199918912.8388.13.camel@lap75545.ornl.gov>
	<1199996752.9159.46.camel@lap75545.ornl.gov>
	<20080110234438.4826f658@inria.fr>
	<1200020661.5099.3.camel@obelisk.thedillows.org>
	<20080111090723.GI6258@kernel.dk>
	<20080111092334.GA8143@elte.hu>
	<20080111092513.GO6258@kernel.dk>
	<20080111094205.GE8143@elte.hu>
	<20080111095654.GR6258@kernel.dk>
	<20080111102953.GA27223@elte.hu>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> Correction: it was not a high res time source, it was "the scheduler's 
> per-cpu, non-exported, non-coherent, warps-and-jumps-like-hell high-res 
> timesource that was intentionally called the _sched_ clock" ;-)

I think the warts of cpu_clock() are fixable, except maybe
unsynchronization on SMP which is harder.

-- 
Guillaume
