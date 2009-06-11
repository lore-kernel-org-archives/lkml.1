Return-Path: <linux-kernel-owner+w=401wt.eu-S1760934AbZFKQcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934AbZFKQcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbZFKQby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:31:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49170 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbZFKQby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:31:54 -0400
Message-ID: <4A31316C.8050007@redhat.com>
Date: Thu, 11 Jun 2009 12:31:40 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 4/5] HWPOISON: report sticky EIO for poisoned file
References: <20090611142239.192891591@intel.com> <20090611144430.813191526@intel.com>
In-Reply-To: <20090611144430.813191526@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> This makes the EIO reports on write(), fsync(), or the NFS close()
> sticky enough. The only way to get rid of it may be
> 
> 	echo 3 > /proc/sys/vm/drop_caches
> 
> Note that the impacted process will only be killed if it mapped the page.
> XXX
> via read()/write()/fsync() instead of memory mapped reads/writes, simply
> because it's very hard to find them.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
