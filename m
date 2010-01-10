Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139Ab0AJEup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab0AJEup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 23:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808Ab0AJEuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 23:50:44 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52730 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0AJEun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 23:50:43 -0500
Date: Sun, 10 Jan 2010 04:49:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, jdike@addtoit.com, tglx@linutronix.de,
       mingo@redhat.com
Subject: Re: [PATCH 1/3] generic sys_old_select
Message-ID: <20100110044954.GB19799@ZenIV.linux.org.uk>
References: <20100106172112.GA17163@lst.de> <20100106173258.GJ9882@parisc-linux.org> <20100106173438.GA17660@lst.de> <20100106174109.GA30528@ZenIV.linux.org.uk> <20100108093137.GA28722@lst.de> <4B47B031.5000406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B47B031.5000406@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 02:22:41PM -0800, H. Peter Anvin wrote:
> > If we do that let's do it consistantly for various old syscalls, not
> > an odd one out.
> 
> Yes, and it would be a good idea to do so, rather than hiding all these
> compatibility calls in all kind of random places.
> 
> There is, however, a reason *not* to do it which should be carefully
> considered: by co-locating the compatibility version with the modern
> version, it gets access to static functions that are part of the
> implementation of the modern version.  If we move the compatibility
> versions out, it may entail having to export those statics.

So we don't move such ones...  I agree that it's a separate patch
queue, BTW.
