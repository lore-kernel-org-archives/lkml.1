Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab0BHUsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:48:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61246 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab0BHUsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:48:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] syscalls: add define syscall prefix macro
Date: Mon, 8 Feb 2010 21:48:16 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc8-00053-g43eb7c4-dirty; KDE/4.3.2; x86_64; ; )
Cc: Jason Baron <jbaron@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com
References: <cover.1265142153.git.jbaron@redhat.com> <201002081712.37166.arnd@arndb.de> <20100208175407.GA14187@infradead.org>
In-Reply-To: <20100208175407.GA14187@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002082148.16556.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+n0OM3Rl5WkZhPv+xY32Mz0WDS0WU17W0KQou
 eL6HkUT7A6xwzuRdgj6inSq13lbEPZ0gq6F+OorF5jyEhTGsGQ
 yjX22VOQxdfUZiKyxITCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 February 2010 18:54:07 Christoph Hellwig wrote:
> On Mon, Feb 08, 2010 at 05:12:36PM +0100, Arnd Bergmann wrote:
> > On Monday 08 February 2010, Jason Baron wrote:
> > > So I was trying to keep the names of the arch ia32 compat sys calls the
> > > same, ie 'sys32_blah'. However, I agree a common naming scheme makes
> > > more sense. what about 'arch_compat_sys_blah'? So as to distinguish from
> > > the common compat syscalls 'compat_sys_blah'.
> > 
> > Why do you need to distinguish them? I would hope that we never need to
> > have a kernel with both a generic and an arch specific compat version
> > of the same syscall.
> 
> Well, the usual alignment or number of arguments issues could lead to
> just that.  We should deal with it the same way as for native syscalls.

Ah, right. The arch specific syscall may just be a wrapper calling the
generic function, so we need them both.

	Arnd
