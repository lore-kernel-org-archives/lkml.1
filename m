Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbZD1JMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbZD1JMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZD1JMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:12:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60459 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbZD1JMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:12:33 -0400
Date: Tue, 28 Apr 2009 05:12:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, hch@lst.de,
       roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] FRV: utrace: Remove in-kernel strace code
Message-ID: <20090428091208.GA15076@infradead.org>
References: <20090427161540.16200.23710.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427161540.16200.23710.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 05:15:40PM +0100, David Howells wrote:
> Remove in-kernel strace code from the FRV arch as it's not really needed any
> more.

FYI you might want to remove the utrace in the patch descriptions.  This
is only related to utrace in that utrace requires all architectures to
have new-style ptrace implementations, but as seen by the patches it's a
very good cleanup on it's own.

