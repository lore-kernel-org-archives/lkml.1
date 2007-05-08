Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbXEHWNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbXEHWNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934528AbXEHWNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:13:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54829 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbXEHWNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:13:49 -0400
Date: Wed, 9 May 2007 00:13:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86-64] Add getcpu and epoll_pwait system calls.
Message-ID: <20070508221348.GC17482@one.firstfloor.org>
References: <20070508185145.B9A8E1827261@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508185145.B9A8E1827261@tuatara.stupidest.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 11:37:26AM -0700, Chris Wedgwood wrote:
> Signed-off-by: Chris Wedgwood <cw@f00f.org>
> ---
>  include/asm-x86_64/unistd.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> diff --git a/include/asm-x86_64/unistd.h b/include/asm-x86_64/unistd.h
> index 26e23e0..aa7d4bf 100644
> --- a/include/asm-x86_64/unistd.h
> +++ b/include/asm-x86_64/unistd.h
> @@ -619,6 +619,10 @@ __SYSCALL(__NR_sync_file_range, sys_sync_file_range)
>  __SYSCALL(__NR_vmsplice, sys_vmsplice)
>  #define __NR_move_pages		279
>  __SYSCALL(__NR_move_pages, sys_move_pages)
> +#define __NR_getcpu		280
> +__SYSCALL(__NR_getcpu, sys_getcpu)

Nope.  There already is a getcpu vsyscall. This is not needed.

> +#define __NR_epoll_pwait	281
> +__SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)


Will add thanks

-Andi
