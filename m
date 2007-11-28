Return-Path: <linux-kernel-owner+w=401wt.eu-S1760504AbXK1NZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504AbXK1NZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbXK1NZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:25:10 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56427 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754413AbXK1NZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:25:09 -0500
To: mingo@elte.hu
CC: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <20071128131541.GA4467@elte.hu> (message from Ingo Molnar on Wed,
	28 Nov 2007 14:15:41 +0100)
Subject: Re: -rt doesn't compile for UML
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128125030.GB21791@elte.hu> <E1IxMfh-0006fN-HQ@dorka.pomaz.szeredi.hu> <20071128131518.GA3193@elte.hu> <20071128131541.GA4467@elte.hu>
Message-Id: <E1IxMuP-0006hl-20@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Nov 2007 14:24:57 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > >   CC      kernel/latency_trace.o
> > > kernel/latency_trace.c:28:21: error: asm/rtc.h: No such file or directory
> > > kernel/latency_trace.c:63:3: error: #error Implement cycles_to_usecs.
> > > kernel/latency_trace.c: In function ???____trace???:
> > > kernel/latency_trace.c:658: error: implicit declaration of function ???irqs_disabled_flags???
> > > make[1]: *** [kernel/latency_trace.o] Error 1
> > 
> > hm, just fill those functions in - should be fairly trivial and we can 
> > carry those patches in -rt. (I'd suggest to create an empty 
> > asm-um/rtc.h stub as well, for consistency.)
> 
> trivial == 'far easier than porting -rt to UML' :-)

OK :)

If I get stuck, I'll leave it to Jeff...

Thanks,
Miklos
