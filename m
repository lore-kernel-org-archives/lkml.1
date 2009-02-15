Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZBOVmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZBOVmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 16:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZBOVm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 16:42:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbZBOVm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 16:42:28 -0500
Date: Sun, 15 Feb 2009 13:41:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Bill Nottingham <notting@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, trivial@kernel.org, stable@kernel.org
Subject: Re: [PATCH] Declare PIO_CMAP/GIO_CMAP as compatbile ioctls.
Message-Id: <20090215134144.c29913d9.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.1.10.0902111438280.31014@jikos.suse.cz>
References: <1234279525-25143-1-git-send-email-notting@redhat.com>
	<alpine.LNX.1.10.0902111438280.31014@jikos.suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009 14:41:25 +0100 (CET) Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 10 Feb 2009, Bill Nottingham wrote:
> 
> > Otherwise, these don't work when called from 32-bit userspace on 64-bit kernels.

Bill, please remember to add signoffs?  This should all be scripted.

> > ---
> >  fs/compat_ioctl.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> > index 5235c67..9ee71a0 100644
> > --- a/fs/compat_ioctl.c
> > +++ b/fs/compat_ioctl.c
> > @@ -1937,6 +1937,8 @@ ULONG_IOCTL(SET_BITMAP_FILE)
> >  /* Big K */
> >  COMPATIBLE_IOCTL(PIO_FONT)
> >  COMPATIBLE_IOCTL(GIO_FONT)
> > +COMPATIBLE_IOCTL(PIO_CMAP)
> > +COMPATIBLE_IOCTL(GIO_CMAP)
> >  ULONG_IOCTL(KDSIGACCEPT)
> >  COMPATIBLE_IOCTL(KDGETKEYCODE)
> >  COMPATIBLE_IOCTL(KDSETKEYCODE)
> > -- 
> > 1.6.1.2
> 
> Alan, I am hesitant to consider this material implicitly applicable for 
> trivial tree.

No, it isn't appropriate for the trivial tree.

> Could you please give your Acked-by for it so that I can 
> merge, or take it through your tree completely?

afaict this fix is needed all the way back to 2.6.tiny.  I merged it
with 2.6.29 intentions.  Also tagged as needed in 2.6.25.x and later.

