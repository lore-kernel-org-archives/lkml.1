Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZI3Ndd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZI3Ndd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 09:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbZI3Ndd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 09:33:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42356 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbZI3Ndc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 09:33:32 -0400
Date: Wed, 30 Sep 2009 09:33:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josh Stone <jistone@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add a stub for mpage_da_data in the trace header
Message-ID: <20090930133335.GA14585@infradead.org>
References: <1254260407-14276-1-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254260407-14276-1-git-send-email-jistone@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 02:40:07PM -0700, Josh Stone wrote:
> The tracepoint ext4_da_write_pages has a struct mpage_da_data*
> parameter, but that struct is only defined in fs/ext4/ext4.h.  This
> patch adds a forward declaration for that struct, so this tracepoint
> header can still be used by tools like SystemTap.

That's not what the tracepoints are for anyway.  No hacks for out of
tree crap like this please - just use the trace buffer directly like
ftrace and then you don't actually need any data types.

