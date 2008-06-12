Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbYFLLZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbYFLLZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 07:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYFLLZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 07:25:34 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59857 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbYFLLZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 07:25:33 -0400
X-Sasl-enc: m9G/QjrQHPO8ZfviSteO/ijTAeVwZF8nBY/4WuPUIlMl 1213269932
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Moyer <jmoyer@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <50414.195.41.66.226.1213254146.squirrel@mail.jabbernet.dk>
References: <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212509263.3025.66.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
	 <1212513189.3025.101.camel@raven.themaw.net>
	 <20080603173029.GD28946@ZenIV.linux.org.uk>
	 <x49ej7ejtry.fsf@segfault.boston.devel.redhat.com>
	 <20080603191859.GG28946@ZenIV.linux.org.uk>
	 <x49abi2jnwf.fsf@segfault.boston.devel.redhat.com>
	 <20080603230026.GH28946@ZenIV.linux.org.uk>
	 <1212547323.3146.45.camel@raven.themaw.net>
	 <1213073861.3024.34.camel@raven.themaw.net>  <484E1F20.4060804@krogh.cc>
	 <1213080010.3024.42.camel@raven.themaw.net>
	 <1213239782.4994.79.camel@raven.themaw.net>
	 <50414.195.41.66.226.1213254146.squirrel@mail.jabbernet.dk>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 19:21:26 +0800
Message-Id: <1213269686.4994.105.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-12 at 09:02 +0200, Jesper Krogh wrote:
> > On Tue, 2008-06-10 at 14:40 +0800, Ian Kent wrote:
> > The patch below is sufficiently different to the original patch I posted
> > to warrant a replacement rather than a correction.
> 
> I'll patch that in now and see what it gives. (Is it preferred
> to use this --ghost option or not?) What would you suggest?

It is a matter of choice mostly.
If you have a large number of entries in your map then don't use it. It
will result in a performance hit especially during expires.

Ian


