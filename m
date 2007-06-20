Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbXFTXWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbXFTXWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXFTXWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:22:42 -0400
Received: from twin.jikos.cz ([213.151.79.26]:59818 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbXFTXWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:22:41 -0400
Date: Thu, 21 Jun 2007 01:22:34 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Timo Sirainen <tss@iki.fi>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray-lk@madrabbit.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SMP read() stopping at memory page boundaries
In-Reply-To: <1182361700.3768.107.camel@hurina>
Message-ID: <Pine.LNX.4.64.0706210121310.3068@twin.jikos.cz>
References: <1182351171.3768.65.camel@hurina>  <1182354493.3768.80.camel@hurina>
  <2c0942db0706200922i15ce44b0xceaed95d002dba33@mail.gmail.com> 
 <1182358622.3768.98.camel@hurina>  <20070620180500.6e2d600a@the-village.bc.nu>
 <1182361700.3768.107.camel@hurina>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Timo Sirainen wrote:

> > It will occur if you are reading as someone else changes the file size.
> > Use file locking, it exists for a reason ;)
> Annoying extra overhead. Especially with NFS, when nowadays you can't
> even use flock() to create local locks..

It's not only "nowadays", it has been like that for quite a some time.

On the other hand you can use fcntl(F_SETLK) though, which works even 
through NFS (v3).

-- 
Jiri Kosina
