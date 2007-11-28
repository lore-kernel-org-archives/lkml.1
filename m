Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbXK1JiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbXK1JiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbXK1JiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:38:12 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47476 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755179AbXK1JiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:38:11 -0500
To: akpm@linux-foundation.org
CC: jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
In-reply-to: <20071127213801.4def3c23.akpm@linux-foundation.org> (message from
	Andrew Morton on Tue, 27 Nov 2007 21:38:01 -0800)
Subject: Re: [uml-devel] leak in do_ubd_request
References: <E1Ix3Du-0002aL-Ac@dorka.pomaz.szeredi.hu>
	<E1Ix58o-0004J5-Mz@dorka.pomaz.szeredi.hu>
	<20071127201105.GA9332@c2.user-mode-linux.org>
	<E1Ix73b-0004aI-Px@dorka.pomaz.szeredi.hu>
	<20071127222020.GA10096@c2.user-mode-linux.org> <20071127213801.4def3c23.akpm@linux-foundation.org>
Message-Id: <E1IxJMf-00067v-2r@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Nov 2007 10:37:53 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 27 Nov 2007 17:20:20 -0500 Jeff Dike <jdike@addtoit.com> wrote:
> 
> > On Tue, Nov 27, 2007 at 09:29:23PM +0100, Miklos Szeredi wrote:
> > > Sure.  The patch works for me, but please check that it also makes
> > > sense.
> > 
> > I did - it's a straight-forward leak and fix.
> > 
> 
> Do we have any idea which patch this patch fixes?

I seems like a mainline bug, and has been present for some time
(forever?).

I have no idea why this wasn't noticed earlier.

Miklos
