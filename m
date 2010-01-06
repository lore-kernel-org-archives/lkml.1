Return-Path: <linux-kernel-owner+w=401wt.eu-S932480Ab0AFRfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab0AFRfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932407Ab0AFRfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:35:38 -0500
Received: from verein.lst.de ([213.95.11.210]:35808 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329Ab0AFRfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:35:37 -0500
Date: Wed, 6 Jan 2010 18:34:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux@arm.linux.org.uk, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       gerg@uclinux.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/3] generic sys_old_select
Message-ID: <20100106173438.GA17660@lst.de>
References: <20100106172112.GA17163@lst.de> <20100106173258.GJ9882@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106173258.GJ9882@parisc-linux.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 10:32:59AM -0700, Matthew Wilcox wrote:
> On Wed, Jan 06, 2010 at 06:21:12PM +0100, Christoph Hellwig wrote:
> > Add a generic implementation of the old select syscall, which expects it's
> > argument in a memory block and switch all architectures over to use it.
> 
> Don't we want an ifdef around compat_sys_old_select() like the one
> around sys_old_select()?

Because nothing in compat.c does it.  If we want to bother saving those
few bites we should do it for more functions, and in a consistant way.

