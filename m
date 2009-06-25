Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbZFYDAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbZFYDAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 23:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZFYDAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 23:00:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772AbZFYDAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 23:00:39 -0400
Date: Wed, 24 Jun 2009 20:00:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Gerard Lledo <gerard.lledo@gmail.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [JFFS2] jffs2_start_garbage_collect_thread() return
 value cleanup
Message-Id: <20090624200029.d875c48e.akpm@linux-foundation.org>
In-Reply-To: <1245838141.25547.5207.camel@macbook.infradead.org>
References: <20090602113216.GA3513@tank>
	<1243944686-7039-1-git-send-email-gerard.lledo@gmail.com>
	<1243944686-7039-2-git-send-email-gerard.lledo@gmail.com>
	<1245838141.25547.5207.camel@macbook.infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 11:09:01 +0100 David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2009-06-02 at 15:11 +0300, Gerard Lledo wrote:
> > There is no user of this return value in the kernel.  Change it to return void
> > instead.
> 
> NAK. I hate this type of patch.
> 
> A function _should_ return an error value indicating success or failure,
> if there's _any_ chance that it (or a future rewrite of it) may fail.
> 
> It's up to the _callers_ to act on that result, or not, as they see fit.

True.

> Andrew, may I suggest that you look for such justification in future
> patches of this type?

eh, I sometimes don't even look at them.  I just save them up in case of
maintainer fumblage.

I might retain this one as a "jffs2 fails to check
jffs2_start_garbage_collect_thread() return value" bug report :)
