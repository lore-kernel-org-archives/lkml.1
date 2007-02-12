Return-Path: <linux-kernel-owner+w=401wt.eu-S1030463AbXBLXIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030463AbXBLXIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030464AbXBLXIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:08:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46478 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030463AbXBLXIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:08:09 -0500
Date: Mon, 12 Feb 2007 15:08:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: build error: allnoconfig fails on mincore/swapper_space
Message-Id: <20070212150802.f240e94f.akpm@linux-foundation.org>
In-Reply-To: <20070212145040.c3aea56e.randy.dunlap@oracle.com>
References: <20070212145040.c3aea56e.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 12 Feb 2007 14:50:40 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 2.6.20-git8 on x86_64:
> 
> 
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> mm/built-in.o: In function `sys_mincore':
> (.text+0xe584): undefined reference to `swapper_space'
> make: *** [.tmp_vmlinux1] Error 1

oops.  CONFIG_SWAP=n,  I assume?
