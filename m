Return-Path: <linux-kernel-owner+w=401wt.eu-S2993415AbXEBP7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993415AbXEBP7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993427AbXEBP7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:59:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54161 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993415AbXEBP7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:59:12 -0400
Date: Wed, 2 May 2007 17:02:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: do_tty_write() can block even with O_NONBLOCK?
Message-ID: <20070502170250.09ae354c@the-village.bc.nu>
In-Reply-To: <17976.43884.191895.235227@zeus.sw.starentnetworks.com>
References: <17976.43884.191895.235227@zeus.sw.starentnetworks.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 11:17:00 -0400
Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com> wrote:

> 
> I have two processes with the same tty open, one opens blocking and
> one opens nonblocking.
> 
> If the blocking process blocks doing a write (due to flow control,
> just going to fast, etc...) the nonblocking process will also block
> when it writes until the blocking process unblocks.
> 
> This seems to occur because do_tty_write() isn't checking for
> O_NONBLOCK when taking the tty's write mutex.
> 
> 
> Signed-off-by: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>

Acked-by: Alan Cox <alan@redhat.com>

Looks fine to me.
