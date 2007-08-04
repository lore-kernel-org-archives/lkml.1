Return-Path: <linux-kernel-owner+w=401wt.eu-S932607AbXHEAYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbXHEAYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 20:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765220AbXHEAYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 20:24:30 -0400
Received: from smtp1.ist.utl.pt ([193.136.128.21]:47487 "EHLO smtp1.ist.utl.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686AbXHEAY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 20:24:29 -0400
X-Greylist: delayed 1945 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Aug 2007 20:24:29 EDT
From: Claudio Martins <ctpm@ist.utl.pt>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Date: Sun, 5 Aug 2007 00:51:40 +0100
User-Agent: KMail/1.9.7
Cc: Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?q?J=F6rn_Engel?= <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
References: <20070803123712.987126000@chello.nl> <46B4E161.9080100@garzik.org> <20070804224706.617500a0@the-village.bc.nu>
In-Reply-To: <20070804224706.617500a0@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708050051.40758.ctpm@ist.utl.pt>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 August 2007, Alan Cox wrote:
>
> Linux has never been a "suprise your kernel interfaces all just changed
> today" kernel, nor a "gosh you upgraded and didn't notice your backups
> broke" kernel.
>

 Can you give examples of backup solutions that rely on atime being updated?
I can understand backup tools using mtime/ctime for incremental backups (like 
tar + Amanda, etc), but I'm having trouble figuring out why someone would 
want to use atime for that.

 Best regards

Claudio

