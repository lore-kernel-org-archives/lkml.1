Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbZEFHJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbZEFHJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZEFHJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:09:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49432 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZEFHJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:09:30 -0400
Date: Wed, 6 May 2009 03:08:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, chrisw@sous-sol.org, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD +
	exit_state instead of ->mm
Message-ID: <20090506070837.GA3223@infradead.org>
References: <20090505224722.GA954@redhat.com> <20090505164733.54cd4ca4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505164733.54cd4ca4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 04:47:33PM -0700, Andrew Morton wrote:
> These patches make a mess of utrace-core.patch.  Do we really want to do that?

Yes.  All these patches from Oleg are preparations for actually doing
a utrace merge in a sane way.  I don't really think utrace should be
in -mm at this point where active ptrace work is going on.

