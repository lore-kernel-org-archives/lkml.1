Return-Path: <linux-kernel-owner+w=401wt.eu-S937431AbXGMXJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937431AbXGMXJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759736AbXGMXJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:09:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49762 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758647AbXGMXJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:09:38 -0400
Date: Fri, 13 Jul 2007 16:09:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
cc: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: RE : Re: x86 setup code rewrite in C - revised
In-Reply-To: <700342.61011.qm@web26915.mail.ukl.yahoo.com>
Message-ID: <alpine.LFD.0.999.0707131609040.20061@woody.linux-foundation.org>
References: <700342.61011.qm@web26915.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Jul 2007, Etienne Lorrain wrote:
>
> > >>  Also, I do not know if "m" is right in here:
> > >> static inline u8 rdfs8(addr_t addr)
> > >> {
> > >> 	u8 v;
> > >> 	asm("movb %%fs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
> > >> 	return v;
> > >> }
> > 
> > The "m" is correct right there.
> 
>  strange, "g" would mean anything can go there - and this assembly instruction
> should accept every access modes.

No it damn well should NOT.

the %fs: override works only with memory ops. End of story.

		Linus
