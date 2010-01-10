Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315Ab0AJEvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab0AJEvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 23:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038Ab0AJEvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 23:51:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52736 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0AJEvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 23:51:08 -0500
Date: Sun, 10 Jan 2010 04:51:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, takata@linux-m32r.org, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, ralf@linux-mips.org,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 3/3] generic sys_ipc wrapper
Message-ID: <20100110045103.GC19799@ZenIV.linux.org.uk>
References: <20100106172152.GC17163@lst.de> <20100108095023.GA29560@lst.de> <20100108100347.GA30353@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108100347.GA30353@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 11:03:47AM +0100, Christoph Hellwig wrote:
> On Fri, Jan 08, 2010 at 10:50:23AM +0100, Christoph Hellwig wrote:
> > Always return -EINVAL for the iBCS2 special case in SHMAT, and add a
> > prototype to linux/syscalls.h
> 
> and stop compiling the generic sys_ipc on s390:

... and maybe update the commit message?  Other than that, ACK.
