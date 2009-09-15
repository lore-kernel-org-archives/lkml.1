Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbZIOIZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbZIOIZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbZIOIZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:25:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:49236 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772AbZIOIZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:25:50 -0400
Message-ID: <4AAF4F6A.5070901@kernel.org>
Date: Tue, 15 Sep 2009 17:25:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch] x86: export cpu_llc_id for edac drivers
References: <20090915082005.4701.86110.sendpatchset@localhost.localdomain>
In-Reply-To: <20090915082005.4701.86110.sendpatchset@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 08:25:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heh.. was about to send out the same patch.

Amerigo Wang wrote:
> When I compiled today's Linus tree, I got a link error from
> drivers/edac/edac_mce_amd.c:408, it complained about not finding
> symbol 'per_cpu__cpu_llc_id'. This is due to we don't export
> 'cpu_llc_id'.
> 
> This patch fixes it.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Mike Travis <travis@sgi.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
