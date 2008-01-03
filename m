Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164AbYACM4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbYACM4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 07:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYACM4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 07:56:14 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59268 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYACM4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 07:56:14 -0500
To: jdike@addtoit.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
In-reply-to: <20080102220519.GA10137@c2.user-mode-linux.org> (message from
	Jeff Dike on Wed, 2 Jan 2008 17:05:19 -0500)
Subject: Re: [uml-devel] UML woes in 2.6.24-rc6-mm1
References: <E1JA7m0-0007nP-Fi@pomaz-ex.szeredi.hu> <20080102200621.GB8847@c2.user-mode-linux.org> <E1JAAZt-0008F8-An@pomaz-ex.szeredi.hu> <20080102220519.GA10137@c2.user-mode-linux.org>
Message-Id: <E1JAPc5-00011g-JJ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 03 Jan 2008 13:55:57 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 32bit UML, 64bit host, config attached.
> 
> Hadn't tried that, but that works here too.
> 
> I'll see if your config reproduces it.
> 
> > Can't reproduce with plain -rc6.
> 
> Feel like bisecting -mm1?

This is the one: uml-runtime-detection-of-host-vmsplit-on-i386.patch

The relevant log line (both for successful and failed boots):

Locating the top of the address space ... 0xffc00000

Miklos

