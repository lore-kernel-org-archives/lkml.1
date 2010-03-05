Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab0CETwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:52:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755361Ab0CETwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:52:21 -0500
Date: Fri, 5 Mar 2010 11:49:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, tony.luck@intel.com, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@redhat.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 4/6] improve sys_personality for compat architectures
Message-Id: <20100305114911.ef629eb1.akpm@linux-foundation.org>
In-Reply-To: <20100204160057.GA5120@lst.de>
References: <201002021536.51928.arnd@arndb.de>
	<20100203.091309.52886984.davem@davemloft.net>
	<4B69D6BA.4030704@zytor.com>
	<201002040838.10783.arnd@arndb.de>
	<20100204160057.GA5120@lst.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 17:00:57 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Feb 04, 2010 at 08:38:10AM +0100, Arnd Bergmann wrote:
> > I think it would be better to have a consistent behavior across
> > architectures, so /something/ should be changed. On x86, the unused
> > sys32_personality function can probable just be removed, if nothing
> > else.
> > 
> > If we can get everyone to agree with the x86 way of handling this,
> > we can also remove all the special cases for sys32_personality in the
> > other architectures.
> 
> Yes, this should be common over architectures.  Anyway, I expect there
> to be some discussion until we've reached that point, so for now I'll
> rebase patches 5 and 6 to not require this patch, and will send one
> to kill the unused x86 implementation.  Whatever is the final outcome
> can be implemented on top.
> 

This never happened?
