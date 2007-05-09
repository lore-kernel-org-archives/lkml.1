Return-Path: <linux-kernel-owner+w=401wt.eu-S968816AbXEID0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968816AbXEID0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934910AbXEID0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:26:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59624 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbXEID0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:26:15 -0400
Date: Wed, 9 May 2007 12:26:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@osdl.org,
       clameter@sgi.com, mel@csn.ul.ie
Subject: Re: [RFC] memory hotremove patch take 2 [10/10] (retry swap-in
 page)
Message-Id: <20070509122605.e178e516.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070509120947.B91A.Y-GOTO@jp.fujitsu.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
	<20070509120947.B91A.Y-GOTO@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2007 12:12:32 +0900
Yasunori Goto <y-goto@jp.fujitsu.com> wrote:

> There is a race condition between swap-in and unmap_and_move().
> When swap-in occur, page_mapped might be not set yet.
> So, unmap_and_move() gives up at once, and tries later.
> 
> 
Note: this will not happen in sys_migratepage(), it holds mm->sem and
gathers migration target page from page table.

-Kame

