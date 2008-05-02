Return-Path: <linux-kernel-owner+w=401wt.eu-S936542AbYEBUep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936542AbYEBUep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936078AbYEBUeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:34:13 -0400
Received: from lazybastard.de ([212.112.238.170]:37050 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934794AbYEBUeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:34:12 -0400
Date: Fri, 2 May 2008 22:33:52 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: LogFS merge
Message-ID: <20080502203352.GC24080@logfs.org>
References: <20080502133234.GA24080@logfs.org> <84144f020805020749r55d5bd3eta82b5cdadb5fffea@mail.gmail.com> <20080502153114.GA7376@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080502153114.GA7376@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 11:31:14 -0400, Christoph Hellwig wrote:
> On Fri, May 02, 2008 at 05:49:38PM +0300, Pekka Enberg wrote:
> > You probably want an ACK from the VFS maintainers before aiming at
> > mainline. But it surely makes sense to ask Andrew to pull it in -mm
> > now.
> 
> Definitively wants a re-review with all the bits from last time fixed.
> 
> How did the inode_lock abuse get fixed, btw?  That one was rather
> lethal.

That wart is still itching.  I thought I'd need a core patch to remove
it, but looking at it again, I might get away with a private spinlock.

Will get fixed.

Jörn

-- 
Happiness isn't having what you want, it's wanting what you have.
-- unknown
