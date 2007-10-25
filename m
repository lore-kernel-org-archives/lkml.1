Return-Path: <linux-kernel-owner+w=401wt.eu-S1760440AbXJYDbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760440AbXJYDbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbXJYDbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:31:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755399AbXJYDbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:31:15 -0400
Date: Wed, 24 Oct 2007 20:31:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 2/5] Use macros instead of TASK_ flags
Message-Id: <20071024203113.615682a4.akpm@linux-foundation.org>
In-Reply-To: <1193228698799-git-send-email-matthew@wil.cx>
References: <11932286982175-git-send-email-matthew@wil.cx>
	<1193228698799-git-send-email-matthew@wil.cx>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 08:24:55 -0400 Matthew Wilcox <matthew@wil.cx> wrote:

> Abstracting away direct uses of TASK_ flags allows us to change the
> definitions of the task flags more easily.
> 
> Also restructure do_wait() a little

umm, spose so.

There's an excellent chance that a millionth of our monkeys will come
along and wreck this diff during the next two months.  In which case
I might end up dropping bits of it, we'll see.

It would be much better if this patch was a series of patches: one to add
the new infrastructure and one-per-subsystem to introduce users of the
infrastructure.  That way I wouldn't have to go mucking around in the
internals of the patch and remembering to tell you when I tossed bits of it
out, and which bits those were.

This shouldn't come as news to an old-timer :(
