Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654Ab0AHJmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab0AHJmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 04:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112Ab0AHJmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 04:42:12 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:56389 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0AHJmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 04:42:11 -0500
Date: Fri, 8 Jan 2010 10:42:09 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, starvik@axis.com,
       jesper.nilsson@axis.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       gerg@uclinux.org, schwidefsky@de.ibm.com, jdike@addtoit.com,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/3] generic sys_old_mmap
Message-ID: <20100108094209.GA29213@osiris.boeblingen.de.ibm.com>
References: <20100106172135.GB17163@lst.de>
 <20100106222716.GA11394@osiris.boeblingen.de.ibm.com>
 <20100108093617.GB28722@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108093617.GB28722@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 10:36:17AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 06, 2010 at 11:27:16PM +0100, Heiko Carstens wrote:
> > On Wed, Jan 06, 2010 at 06:21:35PM +0100, Christoph Hellwig wrote:
> > > Add a generic implementation of the old mmap syscall, which expects it's
> > > argument in a memory block and switch all architectures over to use it.
> > 
> > No compat version here?
> 
> There are only three architectures that would require it, and out of
> those ia64 can't share the common one because of it's subpage protection
> hacks.  In the end I didn't bother.

Ok, then I add the missing compat_ptr handling in the s390 specific compat
syscall :)
