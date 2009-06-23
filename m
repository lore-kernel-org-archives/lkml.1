Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbZFWItd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbZFWItd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZFWItY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:49:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003AbZFWItY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:49:24 -0400
Date: Tue, 23 Jun 2009 01:48:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hch@infradead.org
Subject: Re: merging the per-bdi writeback patchset
Message-Id: <20090623014835.1fc8fb14.akpm@linux-foundation.org>
In-Reply-To: <20090623081156.GT31415@kernel.dk>
References: <20090623081156.GT31415@kernel.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 10:11:56 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> Things are looking good for this patchset and it's been in -next for
> almost a week without any reports of problems. So I'd like to merge it
> for 2.6.31 if at all possible. Any objections?

erk.  I was rather expecting I'd have time to have a look at it all.

It's unclear to me actually _why_ the performance changes which were
observed have actually occurred.  In fact it's a bit unclear (to me)
why the patchset was written and what it sets out to achieve :(

A long time ago the XFS guys (Dave Chinner iirc) said that XFS needs
more than one thread per device to keep the device saturated.  Did that
get addressed?

(kthread_run() returns an ERR_PTR() on error, btw - not NULL.)

