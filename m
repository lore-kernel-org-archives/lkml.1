Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbZE1Ics@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbZE1Ics (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZE1Icc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:32:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965AbZE1Ica (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:32:30 -0400
Date: Thu, 28 May 2009 01:31:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <andi@firstfloor.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/2] remove CONFIG_UNEVICTABLE_LRU definition from
 defconfig
Message-Id: <20090528013146.6dd99aa0.akpm@linux-foundation.org>
In-Reply-To: <20090514111519.9B5D.A69D9226@jp.fujitsu.com>
References: <20090514110357.9B54.A69D9226@jp.fujitsu.com>
	<20090514111519.9B5D.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 11:15:49 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Subject: [PATCH] remove CONFIG_UNEVICTABLE_LRU definition from defconfig
> 
> Now, There isn't CONFIG_UNEVICTABLE_LRU. these line are unnecessary.
> 
> ...
>
>  196 files changed, 196 deletions(-)

Gad.

I don't know if this is worth bothering about really.  The dead Kconfig
option will slowly die a natural death as people refresh the defconfig
files.

