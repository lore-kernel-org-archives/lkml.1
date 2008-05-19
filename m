Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbYESHsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbYESHsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 03:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYESHrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 03:47:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38458 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbYESHrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 03:47:52 -0400
To: flar@allandria.com
CC: miklos@szeredi.hu, hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080517130132.GB25261@cynthia.pants.nu> (message from Brad
	Boyer on Sat, 17 May 2008 06:01:32 -0700)
Subject: Re: [patch 07/22] fat: dont call notify_change
References: <20080516163136.560107038@szeredi.hu> <20080516163222.235825996@szeredi.hu> <87prrl7rxg.fsf@duaron.myhome.or.jp> <E1JxGLP-000406-Eo@pomaz-ex.szeredi.hu> <20080517130132.GB25261@cynthia.pants.nu>
Message-Id: <E1Jy05W-0007cv-UK@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 19 May 2008 09:47:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +EXPORT_SYMBOL_GPL(security_inode_setattr);
> 
> Is there any particular reason you made it EXPORT_SYMBOL_GPL? It seems
> like this is replacing functionality that was previously exported
> without a GPL tag. I won't argue forcefully for changing it, but I
> did want to mention it on the list. I understand people wanting to
> make new functionality tagged that way (even though I disagree), but
> this doesn't seem to fit either the notion of an internal thing that
> shouldn't be touched or new functionality.

It's an internal thing: no other filesystem should do this (and IMO
even FAT should not, but some people seem to feel otherwise).

Miklos
