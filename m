Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbXD0Khf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbXD0Khf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbXD0Khf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:37:35 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:34882 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553AbXD0Khe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:37:34 -0400
Date: Fri, 27 Apr 2007 14:45:33 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: mpm@selenic.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: - maps2-add-proc-pid-pagemap-interface-fix.patch removed from -mm tree
Message-ID: <20070427104533.GA6001@localhost.sw.ru>
References: <200704270814.l3R8EnFJ023047@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704270814.l3R8EnFJ023047@shell0.pdx.osdl.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> maps2-add-proc-pid-pagemap-interface.patch

Ohhh, you're repeating december mincore() bug
2f77d107050abc14bc393b34bdb7b91cf670c250

pagemap_read() takes ->mmap_sem for reading
walk_page_range
pagemap_pte_range
add_to_pagemap
flush_pagemap
copy_to_user

