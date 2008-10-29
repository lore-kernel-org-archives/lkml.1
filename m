Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYJ2VXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYJ2VXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYJ2VXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:23:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbYJ2VXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:23:01 -0400
Date: Wed, 29 Oct 2008 17:22:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Rename DECLARE_MUTEX to DEFINE_SEMAPHORE
Message-ID: <20081029212257.GA32598@infradead.org>
References: <20081026120609.GA10728@joi> <20081026164118.GA19812@infradead.org> <20081029210149.GA6820@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029210149.GA6820@joi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 10:16:29PM +0100, Marcin Slusarz wrote:
> Changing the name of DECLARE_MUTEX (to something which tells us what it really
> does) will increase visibility of semaphore uses, don't you think?
> And more visibility means more patches removing its uses.

What it primarily would is cause change churn.  Really, if you want to
do something useful try getting rid of it instead.

