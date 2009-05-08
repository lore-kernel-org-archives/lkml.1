Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbZEHIx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbZEHIx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZEHIxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:53:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:55422 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbZEHIxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:53:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,316,1239001200"; 
   d="scan'208";a="140622897"
Date: Fri, 8 May 2009 16:53:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@tuxonice.net>,
       David Rientjes <rientjes@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 3/5] PM/Hibernate: Move memory shrinking to
	snapshot.c (rev. 2)
Message-ID: <20090508085316.GB25924@localhost>
References: <200905070040.08561.rjw@sisk.pl> <200905072348.59856.rjw@sisk.pl> <200905072351.57381.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905072351.57381.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 05:51:56AM +0800, Rafael J. Wysocki wrote:
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
> Acked-by: Pavel Machek <pavel@ucw.cz>

Acked-by: Wu Fengguang <fengguang.wu@intel.com> 
