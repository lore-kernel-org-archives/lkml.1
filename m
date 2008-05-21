Return-Path: <linux-kernel-owner+w=401wt.eu-S936533AbYEUTfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936533AbYEUTfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936808AbYEUTeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:34:37 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50272 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764336AbYEUTee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:34:34 -0400
To: trond.myklebust@fys.uio.no
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
In-reply-to: <1211397984.7486.38.camel@localhost> (message from Trond
	Myklebust on Wed, 21 May 2008 15:26:24 -0400)
Subject: Re: [patch 11/14] vfs: move executable checking into ->permission()
References: <20080521171458.077908538@szeredi.hu>
	 <20080521171557.399850407@szeredi.hu> <1211393793.7486.15.camel@localhost>
	 <E1Jytgu-00068N-Tp@pomaz-ex.szeredi.hu> <1211397984.7486.38.camel@localhost>
Message-Id: <E1Jyu4x-0006C8-J0@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 21 May 2008 21:34:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > No, we don't want to deny read or write (that's up to the filesystem
> > how it handles it), just want to deny execute if no x bits are set in
> > the mode.
> 
> OK, but when I see something with the name 'exec_permission()', I assume
> that it is going to check for whether or not I have execute permission.
> 
> If that is not the case, then can we please either change the function,
> or change the name?

Yeah, the name's not very good.  Especially that there's an
exec_permission_lite() in the same file, which has nothing to do with
this.

Will try to think of something better.

Miklos
