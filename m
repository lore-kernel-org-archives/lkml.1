Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbYKUJEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbYKUJEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 04:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbYKUJD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 04:03:56 -0500
Received: from h4.dl5rb.org.uk ([81.2.74.4]:57051 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754889AbYKUJDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 04:03:54 -0500
Date: Fri, 21 Nov 2008 09:01:50 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, sandeen@sandeen.net, davem@davemloft.net,
       tony.luck@intel.com, kyle@mcmartin.ca, schwidefsky@de.ibm.com
Subject: Re: [PATCH] generic compat_sys_ustat
Message-ID: <20081121090150.GD16159@linux-mips.org>
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

For the MIPS bits:

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
