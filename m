Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbYIETk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbYIETk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 15:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYIETkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 15:40:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbYIETkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 15:40:47 -0400
Date: Fri, 5 Sep 2008 12:40:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: 2.6.27-rc5-mm1: list corruption during blk_add_timer()
Message-Id: <20080905124039.2c9ebf20.akpm@linux-foundation.org>
In-Reply-To: <20080905172602.GC11569@x200.localdomain>
References: <20080904224004.d3dd3076.akpm@linux-foundation.org>
	<20080905172602.GC11569@x200.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 21:26:02 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Jens, send to Andrew whatever you fixed in git://git.kernel.dk/linux-2.6-block.git for-2.6.28

I went looking, but afaict the whole thing got removed from today's
linux-next.  block/blk-timeout.c isn't there any more.

> 
> [   24.567512] ------------[ cut here ]------------
> [   24.567619] WARNING: at lib/list_debug.c:30 __list_add+0x95/0xa0()
> [   24.567722] list_add corruption. prev->next should be next (ffff88017f9b8420), but was ffff88017f9b8588. (prev=ffff88017f9b8858).


