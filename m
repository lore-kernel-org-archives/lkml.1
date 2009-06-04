Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbZFDJfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbZFDJfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZFDJfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:35:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35320 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbZFDJfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:35:38 -0400
To: csaba@gluster.com
CC: miklos@szeredi.hu, avati@gluster.com, muirj@nortel.com,
       fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, dl-hacking@gluster.com
In-reply-to: <100d90a90906040232ofd2b5ebw8c8d5f677b13e840@mail.gmail.com>
	(message from Csaba Henk on Thu, 4 Jun 2009 11:32:32 +0200)
Subject: Re: [PATCH] fuse: cache invalidation calls
References: <1119562997.1044731244033504415.JavaMail.root@mb1>
	 <E1MC99F-0004l5-JF@pomaz-ex.szeredi.hu> <100d90a90906040232ofd2b5ebw8c8d5f677b13e840@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1MC9MC-0004nV-Ri@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 04 Jun 2009 11:35:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Csaba Henk wrote:
> On Thu, Jun 4, 2009 at 11:22 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Wed, 3 Jun 2009, Anand Avati wrote:
> >> I was wondering how the userland libfuse would be made aware of the
> >> presence of these two notification features?
> >
> > Here's a patch against fuse CVS.  It's also from John Muir.
> 
> In fact, what we were meditating about is the lack of the
> FUSE_KERNEL_MINOR_VERSION bump. Without that, how do the two parties
> negotiate if the rev inval messages are understood? One of John's
> patches in his patchset had it bumped though...

Yes, I removed that intentionally as hopefully this will go in 2.6.31
with the other 10 -> 11 API changes.

Thanks,
Miklos
