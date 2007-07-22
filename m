Return-Path: <linux-kernel-owner+w=401wt.eu-S1759064AbXGVCXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064AbXGVCXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 22:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXGVCWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 22:22:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49171
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbXGVCWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 22:22:52 -0400
Date: Sat, 21 Jul 2007 19:22:51 -0700 (PDT)
Message-Id: <20070721.192251.122832397.davem@davemloft.net>
To: hch@infradead.org
Cc: vonbrand@inf.utfsm.cl, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: sparc64: ERROR: "sys_ioctl" [arch/sparc64/solaris/solaris.ko]
 undefined!
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070720161154.GA17382@infradead.org>
References: <7157.1184937882@laptop13.inf.utfsm.cl>
	<20070720161154.GA17382@infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Fri, 20 Jul 2007 17:11:54 +0100

> On Fri, Jul 20, 2007 at 09:24:42AM -0400, Horst H. von Brand wrote:
> > When building v2.6.22-3478-g275afca on sparc64 (.config attached) I get:
> > 
> >   MODPOST vmlinux
> >   Building modules, stage 2.
> >   MODPOST 463 modules
> > ERROR: "sys_ioctl" [arch/sparc64/solaris/solaris.ko] undefined!
> 
> Sorry, my fault.
> 
> It looked to me like sparc64 exports sys_ioctl on it's own, but it only
> exports compat_sys_ioctl on it's own.
> 
> Here's the fix:

Applied, thanks!
