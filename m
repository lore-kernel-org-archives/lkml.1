Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbXGGHCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbXGGHCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 03:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbXGGHCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 03:02:11 -0400
Received: from ozlabs.org ([203.10.76.45]:41124 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbXGGHCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 03:02:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18063.14949.850984.791608@cargo.ozlabs.ibm.com>
Date: Sat, 7 Jul 2007 17:01:57 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrea Arcangeli <andrea@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
In-Reply-To: <20070706222651.GG5777@v2.random>
References: <20070706222651.GG5777@v2.random>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli writes:

> So my whole idea is to once and for all to decuple the size of the
> pte-entry (4k on x86/amd64) with the page allocator granularity. The
> HARD_PAGE_SHIFT will be 4k still, the common code PAGE_SIZE will be
> variable and configurable at compile time with CONFIG_PAGE_SHIFT.

How does the page cache work with your scheme?  For example if I have
1000 1kB files cached in the page cache, and 16k PAGE_SIZE, does that
use up 4M, or 16M?

Paul.
