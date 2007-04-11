Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbXDKNug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbXDKNug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 09:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbXDKNuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 09:50:35 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54634 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571AbXDKNue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 09:50:34 -0400
X-Sasl-enc: XZSGDUu5jTbtJi1+06js/QkDWAP3r3v4/7nm9Bf/NeJy 1176299433
Subject: Re: [patch 0/8] unprivileged mount syscall
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hpa@zytor.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1HbaNO-0005AV-00@dorka.pomaz.szeredi.hu>
References: <20070404183012.429274832@szeredi.hu>
	 <20070406160238.f3178189.akpm@linux-foundation.org>
	 <4616D4D4.6020405@zytor.com> <1176195125.3476.47.camel@raven.themaw.net>
	 <E1HbaNO-0005AV-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Wed, 11 Apr 2007 21:48:30 +0800
Message-Id: <1176299311.3377.6.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-32.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-11 at 12:48 +0200, Miklos Szeredi wrote:
> > > >>
> > > >> - users can use bind mounts without having to pre-configure them in
> > > >>   /etc/fstab
> > > >>
> > > 
> > > This is by far the biggest concern I see.  I think the security 
> > > implication of allowing anyone to do bind mounts are poorly understood.
> > 
> > And especially so since there is no way for a filesystem module to veto
> > such requests.
> 
> The filesystem can't veto initial mounts based on destination either.
> I don't think it's up to the filesystem to police bind/move mounts in
> any way.

But if a filesystem can't or the developer thinks that it shouldn't for
some reason, support bind/move mounts then there should be a way for the
filesystem to tell the kernel that.

Surely a filesystem is in a good position to be able to decide if a
mount request "for it" should be allowed to continue based on it's "own
situation and capabilities".

Ian



