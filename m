Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYE1Wtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYE1Wtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 18:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYE1Wt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 18:49:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467AbYE1Wt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 18:49:26 -0400
Date: Wed, 28 May 2008 15:48:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia.Derbey@bull.net
Cc: mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net
Subject: Re: [PATCH] Restore MSGPOOL original value
Message-Id: <20080528154823.e7c700bb.akpm@linux-foundation.org>
In-Reply-To: <20080526091741.735792000@bull.net>
References: <20080526091716.087875000@bull.net>
	<20080526091741.735792000@bull.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 11:17:17 +0200
Nadia.Derbey@bull.net wrote:

> Subject: [PATCH] Restore MSGPOOL original value

Please prefer to include the subsystem identifier in the patch title.  ie:

	[patch] ipc: restore MSGPOOL original value

It saves me from having to do it ;)

> Date: Mon, 26 May 2008 11:17:17 +0200
> User-Agent: quilt/0.45-1
> 
> Hi,
> 
> When posting:
> [PATCH 1/8] Scaling msgmni to the amount of lowmem
> (see http://article.gmane.org/gmane.linux.kernel/637849/), I have changed the
> MSGPOOL value to make it fit what is said in the man pages (i.e. a size in
> bytes).
> 
> But Michael Kerrisk rightly complained that this change could affect the ABI.
> So I'm posting this patch to make MSGPOOL expressed back in Kbytes.
> Michael, on his side, has fixed the man page.
> 
> This patch applies to 2.6.26-rc2-mm1.

But it is needed in 2.6.26, yes?


