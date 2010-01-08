Return-Path: <linux-kernel-owner+w=401wt.eu-S1751808Ab0AHJh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab0AHJh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 04:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445Ab0AHJhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 04:37:24 -0500
Received: from verein.lst.de ([213.95.11.210]:40929 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab0AHJhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 04:37:22 -0500
Date: Fri, 8 Jan 2010 10:36:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux@arm.linux.org.uk, starvik@axis.com, jesper.nilsson@axis.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, schwidefsky@de.ibm.com,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/3] generic sys_old_mmap
Message-ID: <20100108093617.GB28722@lst.de>
References: <20100106172135.GB17163@lst.de> <20100106222716.GA11394@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106222716.GA11394@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 11:27:16PM +0100, Heiko Carstens wrote:
> On Wed, Jan 06, 2010 at 06:21:35PM +0100, Christoph Hellwig wrote:
> > Add a generic implementation of the old mmap syscall, which expects it's
> > argument in a memory block and switch all architectures over to use it.
> 
> No compat version here?

There are only three architectures that would require it, and out of
those ia64 can't share the common one because of it's subpage protection
hacks.  In the end I didn't bother.
