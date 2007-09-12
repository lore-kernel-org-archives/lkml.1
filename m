Return-Path: <linux-kernel-owner+w=401wt.eu-S934345AbXILLxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345AbXILLxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933189AbXILLxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:53:24 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:52964 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbXILLxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:53:23 -0400
Date: Wed, 12 Sep 2007 13:52:57 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Neuling <mikey@neuling.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
       Alan Cox <alan@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] powerpc: add new required termio functions
Message-ID: <20070912115257.GC7858@osiris.boeblingen.de.ibm.com>
References: <8018.1189562679@neuling.org> <20070912102032.GB7858@osiris.boeblingen.de.ibm.com> <20070912040109.3f6a9149.akpm@linux-foundation.org> <20070912113409.GA7253@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912113409.GA7253@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 12:34:09PM +0100, Christoph Hellwig wrote:
> On Wed, Sep 12, 2007 at 04:01:09AM -0700, Andrew Morton wrote:
> > On Wed, 12 Sep 2007 12:20:32 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > 
> > > On Wed, Sep 12, 2007 at 12:04:39PM +1000, Michael Neuling wrote:
> > > > The "tty: termios locking functions break with new termios type" patch
> > > > (f629307c857c030d5a3dd777fee37c8bb395e171) breaks the powerpc compile.
> > > > [...]
> > > > I'm guessing other architectures are broken too?
> > > 
> > > FWIW, the above quoted patch breaks s390 as well.
> > 
> > Does this fix it?

Yes, it does.

> I might be missing something, but the the right fix is probably to
> apply the arch patches from Alan to powerpc and s390.  We don't want to
> be left over without all the nice termios features on these platforms,
> do we?

But not in rc6 timeframe, I would guess?
