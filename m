Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYADTxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYADTxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 14:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYADTxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 14:53:38 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42038 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbYADTxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 14:53:38 -0500
To: jdike@addtoit.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
In-reply-to: <20080104180036.GA6974@c2.user-mode-linux.org> (message from Jeff
	Dike on Fri, 4 Jan 2008 13:00:36 -0500)
Subject: Re: [uml-devel] UML woes in 2.6.24-rc6-mm1
References: <E1JA7m0-0007nP-Fi@pomaz-ex.szeredi.hu> <20080102200621.GB8847@c2.user-mode-linux.org> <E1JAAZt-0008F8-An@pomaz-ex.szeredi.hu> <20080102220519.GA10137@c2.user-mode-linux.org> <E1JAPc5-00011g-JJ@pomaz-ex.szeredi.hu> <20080104180036.GA6974@c2.user-mode-linux.org>
Message-Id: <E1JAsbd-0003lt-0e@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 04 Jan 2008 20:53:25 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is the one: uml-runtime-detection-of-host-vmsplit-on-i386.patch
> > 
> > The relevant log line (both for successful and failed boots):
> > 
> > Locating the top of the address space ... 0xffc00000
> 
> Thanks for narrowing it down.  It turns out I can reproduce it with a
> defconfig, but it reproduces much more easily with your config for
> some reason.
> 
> Anyhow, try the patch below.

Thanks, works for me.

Miklos
