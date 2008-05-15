Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbYEOHpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbYEOHpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbYEOHpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:45:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55373 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbYEOHph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:45:37 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com
In-reply-to: <20080515073901.GT13907@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 15 May 2008 08:39:01 +0100)
Subject: Re: [patch 13/24] vfs: utimes cleanup
References: <20080506091327.259950960@szeredi.hu> <20080506091422.705393283@szeredi.hu> <E1JtK1S-00018D-55@pomaz-ex.szeredi.hu> <20080515073901.GT13907@ZenIV.linux.org.uk>
Message-Id: <E1JwY9N-0006Dw-47@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 May 2008 09:45:17 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > + * do_futimesat - change times on filename
> 
> > +int do_utimes(int dfd, char __user *filename, struct timespec *times, int flags)
> 
> Erm...  Is there any reason to
> 	* have do_utimes() used anywhere
> 	* _not_ have do_futimesat() called "do_utimes"?

Review ping-pong.  My original patch did that, and Christoph didn't
like it.  I don't care that much actually, one thing I like better in
the second version is to have a separate function for the path lookup
thing (now called do_utimes(), but it could be renamed to
name_utimes() or whatever).

Miklos
