Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871Ab0AHJdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0AHJdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 04:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262Ab0AHJd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 04:33:29 -0500
Received: from verein.lst.de ([213.95.11.210]:40905 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0AHJd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 04:33:28 -0500
Date: Fri, 8 Jan 2010 10:31:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, jdike@addtoit.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 1/3] generic sys_old_select
Message-ID: <20100108093137.GA28722@lst.de>
References: <20100106172112.GA17163@lst.de> <20100106173258.GJ9882@parisc-linux.org> <20100106173438.GA17660@lst.de> <20100106174109.GA30528@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106174109.GA30528@ZenIV.linux.org.uk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.734 () BAYES_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 05:41:09PM +0000, Al Viro wrote:
> Actually, I'd be a lot happier if we had lib/syscall/old_select.c, instead
> of cluttering fs/select.c with that.  Objections?

If we do that let's do it consistantly for various old syscalls, not
an odd one out.
