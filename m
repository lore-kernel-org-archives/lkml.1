Return-Path: <linux-kernel-owner+w=401wt.eu-S1763325AbXGZI0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763325AbXGZI0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbXGZI0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:26:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48857 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbXGZI0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:26:34 -0400
Date: Thu, 26 Jul 2007 17:27:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "tony.luck@intel.com" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Zoltan.Menyhart@bull.net,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH] flush icache before set_pte on ia64 take3
Message-Id: <20070726172728.f0c6608c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070726171323.a9c17eda.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070726171323.a9c17eda.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 17:13:23 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>  - lazy_mmu_prot_update() checked pte's executable bit. This was because old
>    Linux's anon page has executable bit. Current kernel doesn't set executable
>    bit on anonymous pages.
> 
Linux's anon page had VM_EXEC bit. Current kernel doesn't set VM_EXEC bit on
anonymous pages. (readable was executable in old days.)

Sorry.. confusing description...
-Kame

