Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbZEDNfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbZEDNfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 09:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbZEDNfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 09:35:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56814 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbZEDNf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 09:35:29 -0400
Date: Mon, 4 May 2009 15:35:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 2/5] PM/Hibernate: Move memory shrinking to snapshot.c
	(rev. 2)
Message-ID: <20090504133520.GA1393@ucw.cz>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905031830.49690.rjw@sisk.pl> <200905040208.43040.rjw@sisk.pl> <200905040211.03569.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905040211.03569.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-05-04 02:11:02, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The next patch is going to modify the memory shrinking code so that
> it will make memory allocations to free memory instead of using an
> artificial memory shrinking mechanism for that.  For this purpose it
> is convenient to move swsusp_shrink_memory() from
> kernel/power/swsusp.c to kernel/power/snapshot.c, because the new
> memory-shrinking code is going to use things that are local to
> kernel/power/snapshot.c .
> 
> [rev. 2: Make some functions static and remove their headers from
>  kernel/power/power.h]
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
