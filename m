Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0CJJBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:01:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56017 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab0CJJBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:01:48 -0500
Date: Wed, 10 Mar 2010 04:01:42 -0500
From: Christoph Hellwig <hch@infradead.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: Re: Nick's vfs-scalability patches ported to 2.6.33-rt
Message-ID: <20100310090142.GA9529@infradead.org>
References: <1267163608.2002.9.camel@work-vm> <20100226060109.GH9738@laptop> <1267659090.4317.67.camel@localhost.localdomain> <20100304033312.GO8653@laptop> <1267675511.4317.78.camel@localhost.localdomain> <1268189462.3339.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268189462.3339.12.camel@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 06:51:02PM -0800, john stultz wrote:
> So this all means that with Nick's patch set, we're no longer getting
> bogged down in the vfs (at least at 8-way) at all. All the contention is
> in the actual filesystem (ext2 in group_adjust_blocks, and ext3 in the
> journal and block allocation code).

Can you check if you're running into any fs scaling limit with xfs?

