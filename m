Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbZIXVPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbZIXVPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbZIXVPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:15:14 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:11656 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbZIXVPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:15:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEALt9u0qrR7PD/2dsb2JhbAC+PIhTAZAIBYQc
X-IronPort-AV: E=Sophos;i="4.44,447,1249257600"; 
   d="scan'208";a="208053483"
From: Roland Dreier <rdreier@cisco.com>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hrtimer: Remove overly verbose "switch to high res mode" message
References: <adavdj92sso.fsf@cisco.com> <adar5tx2s9d.fsf@cisco.com>
	<20090924093800.GA23158@elte.hu> <ada1vlw126s.fsf_-_@cisco.com>
	<1253826764.1806.24.camel@Joe-Laptop.home>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 24 Sep 2009 14:15:14 -0700
In-Reply-To: <1253826764.1806.24.camel@Joe-Laptop.home> (Joe Perches's message
	of "Thu, 24 Sep 2009 14:12:44 -0700")
Message-ID: <adaws3oyrh9.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Sep 2009 21:15:14.0912 (UTC) FILETIME=[1BF9C600:01CA3D5C]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > -	printk(KERN_DEBUG "Switched to high resolution mode on CPU %d\n",
 > > -	       smp_processor_id());
 > 
 > Perhaps pr_debug instead?
 > It gets compiled to nothing unless DEBUG is defined.

Dunno... is that kernel log message ever useful now?

 - R.
