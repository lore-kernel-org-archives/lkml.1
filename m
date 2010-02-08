Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab0BHRyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 12:54:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38475 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab0BHRyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 12:54:13 -0500
Date: Mon, 8 Feb 2010 12:54:07 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Baron <jbaron@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com
Subject: Re: [PATCH 5/6] syscalls: add define syscall prefix macro
Message-ID: <20100208175407.GA14187@infradead.org>
References: <cover.1265142153.git.jbaron@redhat.com> <20100203130104.GB30003@osiris.boeblingen.de.ibm.com> <20100208154856.GC2688@redhat.com> <201002081712.37166.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002081712.37166.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 05:12:36PM +0100, Arnd Bergmann wrote:
> On Monday 08 February 2010, Jason Baron wrote:
> > So I was trying to keep the names of the arch ia32 compat sys calls the
> > same, ie 'sys32_blah'. However, I agree a common naming scheme makes
> > more sense. what about 'arch_compat_sys_blah'? So as to distinguish from
> > the common compat syscalls 'compat_sys_blah'.
> 
> Why do you need to distinguish them? I would hope that we never need to
> have a kernel with both a generic and an arch specific compat version
> of the same syscall.

Well, the usual alignment or number of arguments issues could lead to
just that.  We should deal with it the same way as for native syscalls.

