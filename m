Return-Path: <linux-kernel-owner+w=401wt.eu-S1765844AbXILLee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765844AbXILLee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764693AbXILLeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:34:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41181 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764629AbXILLeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:34:24 -0400
Date: Wed, 12 Sep 2007 12:34:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Michael Neuling <mikey@neuling.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
       Alan Cox <alan@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] powerpc: add new required termio functions
Message-ID: <20070912113409.GA7253@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Michael Neuling <mikey@neuling.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
	Alan Cox <alan@redhat.com>, "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <8018.1189562679@neuling.org> <20070912102032.GB7858@osiris.boeblingen.de.ibm.com> <20070912040109.3f6a9149.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912040109.3f6a9149.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 04:01:09AM -0700, Andrew Morton wrote:
> On Wed, 12 Sep 2007 12:20:32 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > On Wed, Sep 12, 2007 at 12:04:39PM +1000, Michael Neuling wrote:
> > > The "tty: termios locking functions break with new termios type" patch
> > > (f629307c857c030d5a3dd777fee37c8bb395e171) breaks the powerpc compile.
> > > [...]
> > > I'm guessing other architectures are broken too?
> > 
> > FWIW, the above quoted patch breaks s390 as well.
> 
> Does this fix it?

I might be missing something, but the the right fix is probably to
apply the arch patches from Alan to powerpc and s390.  We don't want to
be left over without all the nice termios features on these platforms,
do we?


