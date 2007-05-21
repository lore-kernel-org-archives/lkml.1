Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbXEUIfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbXEUIfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbXEUIfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:35:04 -0400
Received: from nn7.de ([85.214.94.156]:41445 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269AbXEUIfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:35:01 -0400
Subject: Re: 2.6.22-rc2 BUG: at include/linux/slub_def.h:77 kmalloc_index()
From: Soeren Sonnenburg <kernel@nn7.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <465153AF.5030008@gmail.com>
References: <1179728579.11803.1.camel@localhost>
	 <465153AF.5030008@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 21 May 2007 10:34:58 +0200
Message-Id: <1179736498.4980.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 10:09 +0200, Jiri Slaby wrote:
> Soeren Sonnenburg napsal(a):
> > a regression (well I switched to slub) happens on boot...

> > BUG: at include/linux/slub_def.h:77 kmalloc_index()
> >  [<c0176448>] get_slab+0x1c8/0x250
[...]
> Could you try this patch:
> http://lkml.org/lkml/2007/5/19/171

yes, that does fix the issue (at least I don't see the BUG: anymore on
boot). however I can no longer s2ram on 22rc2. 

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
