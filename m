Return-Path: <linux-kernel-owner+w=401wt.eu-S933836AbZJGRne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbZJGRne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757175AbZJGRne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:43:34 -0400
Received: from mail.perches.com ([173.55.12.10]:1995 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbZJGRnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:43:33 -0400
Subject: Re: [PATCH 1/7] printk: clean up return value
From: Joe Perches <joe@perches.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4ACCC87C.5090800@tuffmail.co.uk>
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk>
	 <1254904787-11323-2-git-send-email-alan-jenkins@tuffmail.co.uk>
	 <alpine.LFD.2.01.0910070828190.3432@localhost.localdomain>
	 <1254933396.2134.371.camel@Joe-Laptop.home>
	 <4ACCC87C.5090800@tuffmail.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Oct 2009 10:42:56 -0700
Message-Id: <1254937376.2134.384.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 17:57 +0100, Alan Jenkins wrote:
> Joe Perches wrote:
> > On Wed, 2009-10-07 at 08:36 -0700, Linus Torvalds wrote:
> >> On Wed, 7 Oct 2009, Alan Jenkins wrote:
> >>> We could fix this up, but it seems pointless.  Callers don't really care
> >>> about the extra characters added by printk().  Instead, let's return the
> >>> length of the original message as formatted (and possibly truncated)
> >>> by vscnprintf().
> >> Or we could just change it to 'void'. As Joe Perches says, nobody really 
> >> cares deeply enough for this to generally even matter.
> > Here are changes to make printk/vprintk return void
> > to the only uses I found:
> >  arch/arm/mach-iop13xx/pci.c   |    2 +-
> >  arch/arm/mach-iop13xx/setup.c |    2 +-
> >  drivers/char/mem.c            |    6 ++----
> >  drivers/md/md.c               |    3 +--
> >  drivers/md/raid5.c            |    3 ++-
> >  drivers/net/e100.c            |    9 +++++----
> >  include/linux/kernel.h        |   16 ++++++++--------
> >  include/net/sctp/sctp.h       |    6 +++---
> >  kernel/lockdep.c              |    4 ++--
> >  kernel/printk.c               |   10 +++-------
> >  net/sunrpc/svc.c              |    9 +++------
> >  11 files changed, 31 insertions(+), 39 deletions(-)
> Ok, you beat me to it.
> My second patch will depend on this.  Two questions -
> - May I add it to my series with your Signed-off-by?

Hi Alan.

Sure.  I suggest you verify it first though.

Signed-off-by: Joe Perches <joe@perches.com>

> May I split it up, so I can CC individual maintainers with the
> relevant portions?

Please.  Thanks.  Joe

