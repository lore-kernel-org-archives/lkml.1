Return-Path: <linux-kernel-owner+w=401wt.eu-S935618AbYDQJ7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935618AbYDQJ7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932789AbYDQJcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:32:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44456 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934233AbYDQJcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:32:19 -0400
Date: Thu, 17 Apr 2008 18:36:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [RFC][patch 0/5] Bootmem fixes
Message-Id: <20080417183639.7d3831e0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080416113629.947746497@skyscraper.fehenstaub.lan>
References: <20080416113629.947746497@skyscraper.fehenstaub.lan>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 13:36:29 +0200
Johannes Weiner <hannes@saeurebad.de> wrote:

> Hi,
> 
> here are a bunch of fixes for the bootmem allocator.  These are tested
> on boring x86_32 UMA hardware, but 3 patches only show their effects
> on multi-node systems, so please review and test.
> 
> Only the first two patches are real code changes, the others are
> cleanups.
> 
> `Node-setup agnostic free_bootmem()' assumes that all bootmem
> descriptors describe contiguous regions and bdata_list is in ascending
> order.  Yinghai was unsure about this fact, Ingo could you ACK/NAK
> this?
> 
Tested on ia64/NUMA box  on 2.6.25. seems no problem.

Thanks,
-Kame

