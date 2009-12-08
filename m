Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbZLHHSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbZLHHSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZLHHSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:18:38 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:50240 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbZLHHSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:18:37 -0500
Date: Tue, 8 Dec 2009 16:17:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/19] fix broken aliasing checks for MAP_FIXED on sparc32, mips, arm and sh
Message-ID: <20091208071728.GA25362@linux-sh.org>
References: <E1NHUgf-0007zS-3C@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NHUgf-0007zS-3C@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 03:55:01AM +0000, Al Viro wrote:
> 
> We want addr - (pgoff << PAGE_SHIFT) consistently coloured...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> [MIPS part is in arch tree already]
>  arch/arm/mm/mmap.c               |    3 ++-
>  arch/mips/kernel/syscall.c       |    3 ++-
>  arch/sh/mm/mmap.c                |    3 ++-
>  arch/sparc/kernel/sys_sparc_32.c |    3 ++-
>  4 files changed, 8 insertions(+), 4 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
