Return-Path: <linux-kernel-owner+w=401wt.eu-S939253AbYCSXtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939253AbYCSXtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYCSWTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:19:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S940449AbYCSWTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:19:02 -0400
Date: Wed, 19 Mar 2008 15:17:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86_64 ia32 ptrace vs -ENOSYS
Message-Id: <20080319151758.29e02848.akpm@linux-foundation.org>
In-Reply-To: <20080317045741.2F6A526F995@magilla.localdomain>
References: <20080317045741.2F6A526F995@magilla.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Mar 2008 21:57:41 -0700 (PDT)
Roland McGrath <roland@redhat.com> wrote:

> When we're stopped at syscall entry tracing, ptrace can change the %eax
> value from -ENOSYS to something else.  If no system call is actually made
> because the syscall number (now in orig_eax) is bad, then the %eax value
> set by ptrace should be returned to the user.  But, instead it gets reset
> to -ENOSYS again.  This is a regression from the native 32-bit kernel.
> 
> This change fixes it by leaving the return value alone after entry tracing.

It is unclear (to me) what are the consequences of this problem?  What
are the user-visible effects of the fix?

IOW: is it a 2.6.25 thing and if so, why?

Thanks.
