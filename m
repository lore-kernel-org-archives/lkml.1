Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010Ab0AFRlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab0AFRlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992Ab0AFRlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:41:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52647 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab0AFRlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:41:22 -0500
Date: Wed, 6 Jan 2010 17:41:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux@arm.linux.org.uk, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       gerg@uclinux.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 1/3] generic sys_old_select
Message-ID: <20100106174109.GA30528@ZenIV.linux.org.uk>
References: <20100106172112.GA17163@lst.de> <20100106173258.GJ9882@parisc-linux.org> <20100106173438.GA17660@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106173438.GA17660@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 06:34:38PM +0100, Christoph Hellwig wrote:
> On Wed, Jan 06, 2010 at 10:32:59AM -0700, Matthew Wilcox wrote:
> > On Wed, Jan 06, 2010 at 06:21:12PM +0100, Christoph Hellwig wrote:
> > > Add a generic implementation of the old select syscall, which expects it's
> > > argument in a memory block and switch all architectures over to use it.
> > 
> > Don't we want an ifdef around compat_sys_old_select() like the one
> > around sys_old_select()?
> 
> Because nothing in compat.c does it.  If we want to bother saving those
> few bites we should do it for more functions, and in a consistant way.

Actually, I'd be a lot happier if we had lib/syscall/old_select.c, instead
of cluttering fs/select.c with that.  Objections?
