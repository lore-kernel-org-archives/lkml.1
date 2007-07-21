Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbXGUFtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbXGUFtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 01:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbXGUFtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 01:49:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41380 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601AbXGUFtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 01:49:14 -0400
Date: Fri, 20 Jul 2007 22:48:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 6/7] radixtree: introduce radix_tree_scan_hole()
Message-Id: <20070720224859.38aa0c21.akpm@linux-foundation.org>
In-Reply-To: <384993020.08966@ustc.edu.cn>
References: <20070721044300.909424569@mail.ustc.edu.cn>
	<384993020.08966@ustc.edu.cn>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007 12:43:06 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> Introduce radix_tree_scan_hole(root, index, max_scan) to scan radix tree
> for the first hole. It will be used in interleaved readahead.

If you're ever feeling fantastically bored, please consider updating the
userspace radix-tree test harness for this?  Cook up a couple of testcases
for the new functionality?

Thanks.

http://www.zip.com.au/~akpm/linux/patches/stuff/rtth.tar.gz is the latest.
