Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbYELJYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbYELJYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 05:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbYELJYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 05:24:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42178 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbYELJYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 05:24:04 -0400
Date: Mon, 12 May 2008 18:19:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Dave Hansen <haveblue@us.ibm.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] memory_hotplug: always initialize pageblock bitmap.
Message-Id: <20080512181928.cd41c055.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080512105500.ff89c0d3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080509060609.GB9840@osiris.boeblingen.de.ibm.com>
	<20080509153910.6b074a30.kamezawa.hiroyu@jp.fujitsu.com>
	<20080510124501.GA4796@osiris.boeblingen.de.ibm.com>
	<20080512105500.ff89c0d3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008 10:55:00 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> seems good. I'll try this logic on my ia64 box, which allows
> NUMA-node hotplug.
> 
I'm sorry but I found memory-hotplug on my box doesn't work now
maybe because of recent? changes in linux's ACPI. It seems no notifies
reach to acpi container/memory driver. (maybe another regression...)
I'll dig...but it may take some amount of time.

I have no objection to your patch as a result of review.

Thanks,
-Kame

