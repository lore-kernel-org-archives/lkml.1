Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbYKYRB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbYKYRB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYKYRBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:01:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57454 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYKYRBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:01:45 -0500
Date: Tue, 25 Nov 2008 12:01:41 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, sandeen@sandeen.net, davem@davemloft.net,
       tony.luck@intel.com, ralf@linux-mips.org, kyle@mcmartin.ca,
       schwidefsky@de.ibm.com
Subject: Re: [PATCH] generic compat_sys_ustat
Message-ID: <20081125170141.GA30056@bombadil.infradead.org>
References: <20081121084105.GA7155@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121084105.GA7155@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 09:41:05AM +0100, Christoph Hellwig wrote:
> Due to a different size of ino_t ustat needs a compat handler, but
> currently only x86 and mips provide one.  Add a generic compat_sys_ustat
> and switch all architectures over to it.
> 
> Found by Eric Sandeen when running xfstests/017 on ppc64, which causes
> stack smashing warnings on RHEL/Fedora due to the too large amount of
> data writen by the syscall.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Interesting we've been missing this without noticing...

Acked-by: Kyle McMartin <kyle@mcmartin.ca>
