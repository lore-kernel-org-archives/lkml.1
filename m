Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZCIUg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZCIUg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZCIUgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:36:47 -0400
Received: from mail2.shareable.org ([80.68.89.115]:59264 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZCIUgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:36:47 -0400
Date: Mon, 9 Mar 2009 20:36:24 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Avi Kivity <avi@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com, bcrl@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: remove aio-max-nr and instead use the memlock rlimit to limit the number of pages pinned for the aio completion ring
Message-ID: <20090309203624.GA2812@shareable.org>
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com> <49B54143.1010607@redhat.com> <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com> <49B571C7.3010005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B571C7.3010005@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Or you could queue the completions somewhere, and only copy them to
> user memory when io_getevents() is called.  I think the plan was
> once to allow events to be consumed opportunistically even without
> io_getevents(), though.

Isn't that integrated (or to be integrated) with the vring buffer
thingy used by virtio?

If not, should it be?

> Sorry, I didn't actually take a look at the patches.  I only reacted to 
> the description - I am allergic to pinned memory.

While we're at it I'm allergic to fixed size ring buffers :-)

-- Jamie
