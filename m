Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbXHAGVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbXHAGVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXHAGVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:21:09 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:54476 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbXHAGVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:21:07 -0400
To: trond.myklebust@fys.uio.no
CC: chuck.lever@oracle.com, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, kzak@redhat.com, sfrench@samba.org,
       mark.fasheh@oracle.com, kurt.hackel@oracle.com
In-reply-to: <1185917255.6700.80.camel@localhost> (message from Trond
	Myklebust on Tue, 31 Jul 2007 17:27:35 -0400)
Subject: Re: request for patches: showing mount options
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu>
	 <46AA4AC5.2050200@oracle.com> <E1IEW21-0001kL-00@dorka.pomaz.szeredi.hu>
	 <46AA51CA.7030105@oracle.com> <E1IEezF-0002g6-00@dorka.pomaz.szeredi.hu>
	 <46AE01C2.3000008@oracle.com> <E1IFnSa-0002BL-00@dorka.pomaz.szeredi.hu>
	 <46AF450D.5020106@oracle.com> <E1IFyEK-00042c-00@dorka.pomaz.szeredi.hu>
	 <46AFA6AB.8080208@oracle.com> <1185917255.6700.80.camel@localhost>
Message-Id: <E1IG7ZE-00060y-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 01 Aug 2007 08:20:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2007-07-31 at 17:16 -0400, Chuck Lever wrote:
> > Miklos Szeredi wrote:
> > > It would be nice to have all this stuff in 2.6.24, which doesn't leave
> > > a lot of time.
> > 
> > Yes, that would be nice, but there's a lot of stuff that needs to get 
> > done before this.  NFS IPv6, for example, is a higher priority than 
> > refactoring to remove /etc/mtab -- the US government has a new 
> > requirement in 2008 for IPv6 support in any software that it purchases, 
> > and NFS may be a stumbling block for distributors if it doesn't have it.
> > 
> > So I'd say "no way" for 2.6.24, but it's really Trond's call to make.
> 
> I never like to tell people what their priorities should be. If someone
> is interested enough to do the work, then it will get done, however this
> cannot make the top of my already-overloaded list of priorities for
> 2.6.24, and it would appear that Chuck is busy too.
> 
> Any other volunteers out there?

I'm willing to help out.

I could have basically fixed up all filesystems, but I think it's
better if the maintainers do it and are aware that this needs to be
looked at each time a new option is added.

But there's no problem with making exceptions if the maintainers are
busy.

Miklos


