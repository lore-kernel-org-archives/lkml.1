Return-Path: <linux-kernel-owner+w=401wt.eu-S1759733AbYDKJwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733AbYDKJwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbYDKJwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:52:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41840 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304AbYDKJwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:52:34 -0400
Date: Fri, 11 Apr 2008 18:57:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi
Subject: Re: 2.6.25-rc8-mm2
Message-Id: <20080411185703.a5407940.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080410203354.f0a6f464.akpm@linux-foundation.org>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008 20:33:54 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/
> 
> - Compilation is busted on mips due to the page-flags patches
> 
On ia64/NUMA box (which has empty nodes.)

CONFIG_SLAB ..... booted well
CONFIG_SLUB ..... can't boot
CONFIG_SLUB + CONFIG_SLUB_DEBUG_ON .... booted. Hmm?

I'll dig more if I can.

2.6.25-rc8-mm1 had no troubles.

Thanks,
-Kame

