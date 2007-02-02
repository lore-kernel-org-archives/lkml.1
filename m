Return-Path: <linux-kernel-owner+w=401wt.eu-S1946176AbXBBXwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946176AbXBBXwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 18:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946179AbXBBXwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 18:52:50 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45219 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946174AbXBBXwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 18:52:47 -0500
Date: Fri, 2 Feb 2007 15:52:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: [patch 0/9] buffered write deadlock fix
Message-Id: <20070202155232.babe1a52.akpm@linux-foundation.org>
In-Reply-To: <20070129081905.23584.97878.sendpatchset@linux.site>
References: <20070129081905.23584.97878.sendpatchset@linux.site>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 11:31:37 +0100 (CET)
Nick Piggin <npiggin@suse.de> wrote:

> The following set of patches attempt to fix the buffered write
> locking problems (and there are a couple of peripheral patches
> and cleanups there too).
> 
> Patches against 2.6.20-rc6. I was hoping that 2.6.20-rc6-mm2 would
> be an easier diff with the fsaio patches gone, but the readahead
> rewrite clashes badly :(

Well fsaio is restored, but there's now considerable doubt over it due to
the recent febril febrility.

How bad is the clash with the readahead patches?

Clashes with git-block are likely, too.

Bugfixes come first, so I will drop readahead and fsaio and git-block to get
this work completed if needed - please work agaisnt mainline.

