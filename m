Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZA1IQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZA1IQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 03:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZA1IQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 03:16:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47017 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZA1IQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 03:16:27 -0500
Subject: Re: [RFC v2][PATCH] create workqueue threads only when needed
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alasdair G Kergon <agk@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20090128030224.GA4867@redhat.com>
References: <20090128002714.GA5086@nowhere>
	 <20090128030224.GA4867@redhat.com>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 09:15:39 +0100
Message-Id: <1233130539.10992.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 04:02 +0100, Oleg Nesterov wrote:
> 
> I must admit, I don't like this patch. Perhaps I am wrong, mostly I
> dislike the complications it adds.
> 
> Anybody else please vote for this change?

Because you asked ;-)

I too am not particularly fond of it, for much the same reasons you
mentioned.

While I think its good to reduce the number of random kernel threads,
I'm afraid this isn't a good way to do so.

Why does everybody and his pony create their own workqueue, is that
really because it deadlocks with keventd, or are there other reasons, if
so, which, and can we solve those?

