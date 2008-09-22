Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbYIVSa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbYIVSa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYIVSaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:30:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:40236 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbYIVSaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:30:20 -0400
Date: Mon, 22 Sep 2008 11:29:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Re: mmotm 2008-09-22-01-36 uploaded (memory_hotplug)
Message-Id: <20080922112918.c6ea4e05.randy.dunlap@oracle.com>
In-Reply-To: <200809220838.m8M8cwC2031790@imap1.linux-foundation.org>
References: <200809220838.m8M8cwC2031790@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 01:38:58 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-09-22-01-36 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.27-rc7:


mm/built-in.o: In function `remove_memory':
(.text+0x497ed): multiple definition of `remove_memory'
arch/x86/mm/built-in.o:(.text+0x3d8): first defined here
make[1]: *** [vmlinux.o] Error 1


so it is defined in both mm/memory_hotplug.c and
arch/x86/mm/init_64.c when CONFIG_MEMORY_HOTREMOVE=y.

---
~Randy
