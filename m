Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYFDFzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYFDFzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 01:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYFDFy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 01:54:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40762 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYFDFy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 01:54:57 -0400
Date: Wed, 4 Jun 2008 15:00:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] per-task-delay-accounting: add memory reclaim delay
Message-Id: <20080604150024.a75d8534.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
References: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008 19:38:25 -0700
Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp> wrote:

> +	delayacct_freepages_start();
>  	did_some_progress = try_to_free_pages(zonelist, order, gfp_mask);
> +	delayacct_freepages_end();
> 
Could you move this to vmscan.c do_try_to_free_pages().
Then, memory reclaim from memory resource controller can be catched as well.

Thanks,
-Kame

