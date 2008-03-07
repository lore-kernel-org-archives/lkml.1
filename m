Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbYCGKur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbYCGKur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 05:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbYCGKuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 05:50:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32798 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbYCGKuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 05:50:39 -0500
Date: Fri, 7 Mar 2008 05:50:25 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: do_tkill: don't use tasklist_lock
Message-ID: <20080307105025.GB20000@infradead.org>
References: <20080307095813.GA8894@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307095813.GA8894@tv-sign.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 12:58:13PM +0300, Oleg Nesterov wrote:
> Note that we don't return an error if lock_task_sighand() fails, we pretend the
> task dies after receiving the signal. Otherwise, we should fight with the nasty
> races with mt-exec without having any advantage.

This should be mentioned in a comment in the code.

