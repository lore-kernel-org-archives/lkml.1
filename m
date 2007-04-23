Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbXDWUEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbXDWUEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXDWUDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:03:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:56913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXDWUDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:03:19 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm] cpusets: allow TIF_MEMDIE threads to allocate anywhere
Date: Mon, 23 Apr 2007 22:03:13 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@engr.sgi.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0704231235280.18240@chino.kir.corp.google.com>
In-Reply-To: <Pine.LNX.4.64.0704231235280.18240@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704232203.13659.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +        /*
> +         * Allow tasks that have access to memory reserves because they have
> +         * been OOM killed to get memory anywhere.
> +         */
> +        if (unlikely(test_tsk_thread_flag(current, TIF_MEMDIE)))

This should be test_thread_flag()

-Andi
