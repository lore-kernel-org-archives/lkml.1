Return-Path: <linux-kernel-owner+w=401wt.eu-S1751368AbZJTIj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbZJTIj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 04:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbZJTIj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 04:39:27 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:62211 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbZJTIj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 04:39:26 -0400
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: [PATCH 2/4] kmemleak: Scan the _ftrace_events section in modules
References: <20091019144602.14221.27128.stgit@pc1117.cambridge.arm.com>
	<20091019144928.14221.73541.stgit@pc1117.cambridge.arm.com>
	<200910201124.18695.rusty@rustcorp.com.au>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 20 Oct 2009 09:39:20 +0100
In-Reply-To: <200910201124.18695.rusty@rustcorp.com.au> (Rusty Russell's message of "Tue\, 20 Oct 2009 11\:24\:18 +1030")
Message-ID: <tnx7huqa287.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Oct 2009 08:39:22.0017 (UTC) FILETIME=[D248B110:01CA5160]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tue, 20 Oct 2009 01:19:29 am Catalin Marinas wrote:
>> This section contains pointers to allocated objects and not scanning it
>> leads to false positives.
>
> Thanks, applied.  Want me to push this for 2.6.32?

This patch requires 1/4 to be applied as it changes the kmemleak API a
bit, so it won't even compile on its own. I can push them both
together with your ack for the second.

I'm not sure whether API changes make sense during -rc releases, I was
more thinking of pushing the patches for 2.6.33.

For the current kernel, I could send you patch with the current API,
though calling kmemleak_scan_area() for _ftrace_events is a bit ugly.

Thanks.

-- 
Catalin
