Return-Path: <linux-kernel-owner+w=401wt.eu-S1764923AbXGYHvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764923AbXGYHvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762376AbXGYHuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:50:52 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41861 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761419AbXGYHuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:50:51 -0400
Date: Wed, 25 Jul 2007 09:52:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andy Fleming <afleming@freescale.com>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org
Subject: Re: modpost warning question
Message-ID: <20070725075205.GC24093@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0707250210520.14366@blarg.am.freescale.net> <20070725072712.GB24093@uranus.ravnborg.org> <1409C32B-61A8-49D1-BF64-1CFAA5F8B93B@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409C32B-61A8-49D1-BF64-1CFAA5F8B93B@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> >For the popular architectures (i386,x86_64) we discard .exit.text at
> >runtime so here we do not see the error from ld (sadly).
> 
> Fair point, wondering what we do with .exit on PPC, another thing for  
> the list :)

from:
arch/ppc/kernel/vmlinux.lds.S:
  /* .exit.text is discarded at runtime, not link time,
     to deal with references from __bug_table */
  .exit.text : { *(.exit.text) }

	Sam
