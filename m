Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937Ab0AFPsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0AFPsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 10:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919Ab0AFPsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 10:48:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50203 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab0AFPsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 10:48:41 -0500
Date: Wed, 6 Jan 2010 10:48:14 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: O_* bit numbers uniqueness check
Message-ID: <20100106154814.GA5172@infradead.org>
References: <20100106065526.GB11368@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106065526.GB11368@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 02:55:26PM +0800, Wu Fengguang wrote:
> The O_* bit numbers are defined in 20+ arch/*, and hence can silently
> overlap. Add a boot time check to ensure the uniqueness as suggested
> by David Miller.

The right fix is to stop overlyaing the FMODE_ flags into the O_
namespace.  Al has been working towards this.

