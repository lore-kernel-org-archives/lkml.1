Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbZBUDWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbZBUDWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 22:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZBUDVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 22:21:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:49173 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbZBUDVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:21:54 -0500
Message-ID: <499F7346.5090008@kernel.org>
Date: Sat, 21 Feb 2009 12:21:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: Subject: [PATCH 08/10 UPDATED] vmalloc: add un/map_kernel_range_noflush()
References: <1234958676-27618-1-git-send-email-tj@kernel.org>	<1234958676-27618-9-git-send-email-tj@kernel.org>	<499E589B.6060707@kernel.org> <20090220003229.c3f3abfe.akpm@linux-foundation.org>
In-Reply-To: <20090220003229.c3f3abfe.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 21 Feb 2009 03:21:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Should these be called
> vmap_kernel_range_noflush/vunmap_kernel_range_noflush?
> 
> <avoids pointing out the 2 gigapage limit>

Yeap, having v there would be nicer but there already was an exported
function unmap_kernel_range() and I didn't want to rename the current
users or introduce inconsistent names (or interface).  Hmmmm.... There
aren't many users and we can rename them all but I don't feel it's
really necessary.

Thanks.

-- 
tejun
