Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbXIZBbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbXIZBbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 21:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXIZBbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 21:31:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45036 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbXIZBbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 21:31:43 -0400
Date: Wed, 26 Sep 2007 10:32:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc8-mm1 - powerpc memory hotplug link failure
Message-Id: <20070926103205.c72a8e8a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <46F968C2.7080900@linux.vnet.ibm.com>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
	<46F968C2.7080900@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 01:30:02 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> The 2.6.23-rc8-mm1 kernel linking fails on the powerpc (P5+) box
> 
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `memory_block_action':
> /root/scrap/linux-2.6.23-rc8/drivers/base/memory.c:188: undefined reference to `.remove_memory'
> make: *** [.tmp_vmlinux1] Error 1
> 
Maybe my patch is the problem. could you give me your .config ?

Thanks,
-Kame

