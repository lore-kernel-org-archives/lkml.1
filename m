Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYEWPcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYEWPcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYEWPbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:31:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34978 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbYEWPbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:31:50 -0400
To: zippel@linux-m68k.org
CC: hch@infradead.org, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.64.0805231712120.18302@localhost.localdomain>
	(message from Roman Zippel on Fri, 23 May 2008 17:18:26 +0200 (CEST))
Subject: Re: [patch 06/14] hfsplus: remove hfsplus_permission()
References: <20080521171458.077908538@szeredi.hu> <20080521171549.964767446@szeredi.hu>
 <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
 <E1Jz5gq-0007F4-AQ@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221358080.18302@localhost.localdomain>
 <E1Jz9jk-0007rg-5W@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221427300.18302@localhost.localdomain>
 <E1JzA2r-0007uK-8L@pomaz-ex.szeredi.hu> <20080523092114.GD27119@infradead.org> <Pine.LNX.4.64.0805231712120.18302@localhost.localdomain>
Message-Id: <E1JzZF5-0002Hz-5e@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 23 May 2008 17:31:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes.  Roman, if you care about details about the files as directories
> > look in the reiser4 threads as it did something quite similar.
> 
> I was afraid this would come up. :)
> I only need something much simpler, I don't need to create/move/unlink 
> anything, I only need a lookup+open.

Doesn't matter.  As long as filesystem has hard links and allows
lookup on these, userspace can screw up the kernel.  Badly.

I did some work on this with auto-mounting/umounting directories on
regular files.  Hope to dig it up sometimes, but there are lots of
nasty little details to worry about...

Miklos
