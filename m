Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbXK1Piu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbXK1Piu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbXK1Pin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:38:43 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35251 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754167AbXK1Pim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:38:42 -0500
To: jdike@addtoit.com
CC: mingo@elte.hu, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <20071128150840.GB5518@c2.user-mode-linux.org> (message from Jeff
	Dike on Wed, 28 Nov 2007 10:08:40 -0500)
Subject: Re: -rt doesn't compile for UML
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128125030.GB21791@elte.hu> <E1IxMfh-0006fN-HQ@dorka.pomaz.szeredi.hu> <20071128150840.GB5518@c2.user-mode-linux.org>
Message-Id: <E1IxOzn-00075w-Gq@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Nov 2007 16:38:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Nov 28, 2007 at 02:09:45PM +0100, Miklos Szeredi wrote:
> > kernel/latency_trace.c:28:21: error: asm/rtc.h: No such file or directory
> 
> For things like this, look at the host's asm/foo.h and see if it's
> usable in UML (and contains things that you need).  If it is, just
> make a asm-um/foo.h which just includes "asm/arch/foo.h".

Yeah, I know that trick :)

It doesn't help in this case.  I've gotten as far as realizing that
the latency tracer needs the irqflags tracing
(Documentation/irqflags-tracing.tx) and that UML doesn't yet support
that.

Miklos
