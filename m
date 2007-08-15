Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbXHOGcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbXHOGcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 02:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbXHOGbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 02:31:50 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54226 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751581AbXHOGbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 02:31:50 -0400
X-Sasl-enc: d9EKxSWgldewLFHH0nCwaL1nTNPk/X3WW8S2a54fdcAo 1187159508
Subject: Re: [autofs] [PATCH] autofs4: deadlock during create
From: Ian Kent <raven@themaw.net>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <x49mywuci9i.fsf@segfault.boston.devel.redhat.com>
References: <1187087280.4963.18.camel@raven.themaw.net>
	 <x49mywuci9i.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 14:31:43 +0800
Message-Id: <1187159503.3249.36.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 10:17 -0400, Jeff Moyer wrote:
> Ian Kent <raven@themaw.net> writes:
> >
> > After spending quite a bit of time trying to resolve this on more than
> > one occassion, using rather complex and ulgy approaches, it turns out
> > that just delaying the hashing of the dentry until the create operation
> > work fine.

There seems to be an unexpected problem with the patch after removal of
the d_rehash line left in the original by mistake.

I'm working on it.
Sorry all.

Ian


