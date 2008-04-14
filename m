Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbYDNIL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbYDNIL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbYDNILn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:11:43 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34555 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbYDNILm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:11:42 -0400
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, dwmw2@infradead.org, hch@infradead.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20080414004909.1b21b738.akpm@linux-foundation.org> (message from
	Andrew Morton on Mon, 14 Apr 2008 00:49:09 -0700)
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
	<20080412170304.54f139e2.akpm@linux-foundation.org>
	<20080413033344.GA27494@hash.localnet>
	<20080412205544.5e12a7d4.akpm@linux-foundation.org>
	<20080413080130.GA9622@infradead.org>
	<20080413012001.8d7967f4.akpm@linux-foundation.org>
	<20080413082815.GA20108@infradead.org>
	<E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	<1208121358.2700.4.camel@shinybook.infradead.org>
	<E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu> <20080414004909.1b21b738.akpm@linux-foundation.org>
Message-Id: <E1JlJmk-000532-KL@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 14 Apr 2008 10:11:30 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And I didn't advocate moving
> > ntfs to fuse, still that was done and the resulting filesystem at the
> > moment happens to outperform the kernel one in every respect ;)
> 
> Gad.  Why?

I think mostly because of dedication of the maintainer (Szabolcs
Szakacsits).  I don't claim fuse has a great part in it, except the
obvious advantages of developing in userspace: no kernel crashes,
easier debugging, etc...

And of course it could be ported back to the kernel (ntfs-3g is GPL
too), and that would probably result in even more speedups.  But
that's not a trivial task either.

Miklos
