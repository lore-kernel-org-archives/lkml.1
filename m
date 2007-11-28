Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbXK1RZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbXK1RZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761937AbXK1RZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:25:25 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47234 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761662AbXK1RZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:25:24 -0500
To: jdike@addtoit.com
CC: mingo@elte.hu, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <E1IxQJM-0007LZ-1w@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Wed, 28 Nov 2007 18:02:56 +0100)
Subject: Re: -rt doesn't compile for UML
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128125030.GB21791@elte.hu> <E1IxMfh-0006fN-HQ@dorka.pomaz.szeredi.hu> <20071128150840.GB5518@c2.user-mode-linux.org> <E1IxOzn-00075w-Gq@dorka.pomaz.szeredi.hu> <20071128154152.GA742@elte.hu> <E1IxPKU-00079S-UH@dorka.pomaz.szeredi.hu> <20071128160501.GA7986@elte.hu> <E1IxQEX-0007Ji-TV@dorka.pomaz.szeredi.hu> <E1IxQJM-0007LZ-1w@dorka.pomaz.szeredi.hu>
Message-Id: <E1IxQem-0007P3-69@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Nov 2007 18:25:04 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > OK, managed to make it compile, but then something goes wrong in
> > tracer_alloc_bootmem().
> 
> It needs 32M, and uml has that much by default.  Doh.
> 
> But something is still wrong:
> 
> > /store/quilt/linux/linux mem=64

I'm an idiot, sorry.  It should have been mem=64M.  No wonder it
didn't manage to start with 64 bytes of memory ;)

So now with s/trace_alloc_bootmem/alloc_bootmem and MAX_TRACE set to
4096UL*16UL it boots fine.

Miklos
