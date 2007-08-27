Return-Path: <linux-kernel-owner+w=401wt.eu-S1762645AbXH0QWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762645AbXH0QWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761759AbXH0QSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:18:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35592 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761732AbXH0QSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:18:04 -0400
Date: Mon, 27 Aug 2007 09:17:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/28] Add cmpxchg64_local and cmpxchg_local to each
 architecture
Message-Id: <20070827091726.a2e8fbb8.akpm@linux-foundation.org>
In-Reply-To: <20070827155234.062715780@polymtl.ca>
References: <20070827155234.062715780@polymtl.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 11:52:34 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Here is the patch series for 2.6.23-rc3-mm1 that adds cmpxchg_local, and now
> also cmpxchg64_local, to each architecture.

How well tested are these on the various architectures?

> When the architecture supports it, it also defines cmpxchg64, but is is not
> defined for architecture that does not support atomic 64 bits updates.
> 
> Following performance testing of the slub allocator with cmpxchg_local, these
> patches should prove themselves useful in a near future.

It would be useful if we could have (numerical) details on these benefits as
part of this patch series description, please.

Also, it would be good to get the slub patch in there at the same time so that
the new code gets a bit of exercise.

Thanks.
