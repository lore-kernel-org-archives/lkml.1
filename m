Return-Path: <linux-kernel-owner+w=401wt.eu-S933548AbYBMWmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548AbYBMWmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbYBMWmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:42:35 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:42699 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYBMWmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:42:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Vmg5HErxlKo8/HtMUQvAP+pT8IzIjMhMgSCUYRI7kNPWiX/MyqKjcVVxyA5Ajnz/vBjGvf+N16ssdOf4Tajq7vEnYqV1o4UEQd11g+SDdauHImdYo7CqM/qJMq9vu31shMBuD196pmIeMBOpDPx2Z4DAocn4UBwyWvzkbyyo/Ao=
Subject: Re: [RFC PATCH] feature-removal: add documentation for exported
	symbols going away
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Emelyanov <xemul@openvz.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080213223455.GB12383@cs181133002.pp.htv.fi>
References: <1202941327.18204.11.camel@brick>
	 <20080213223455.GB12383@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 14:42:30 -0800
Message-Id: <1202942550.18204.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-14 at 00:34 +0200, Adrian Bunk wrote:
> On Wed, Feb 13, 2008 at 02:22:06PM -0800, Harvey Harrison wrote:
> > +
> > +What:	__inet_hash_connect
> > +Where:	net/ipv4/inet_hashtables.c
> > +When:	2.6.28
> > +Why:	No in tree users
> > +
> > +---------------------------
> > +
> > +What:	io_delay_type
> > +Where:	arch/x86/kernel/io_delay.c
> > +When:	2.6.28
> > +Why:	No in tree users
> > +
> > +---------------------------
> >...
> 
> NAK.
> 
> It's a well-known and documented fact that we not have a stable API for 
> modules.
> 
> And as long as we anyway break the modules API in so many other cases 
> with each kernel release there's simply no point in not removing exports 
> immediately.
> 
> Oh, and for increasing the amount of nonsense even further, you should 
> explain why unused exports that just sneaked into 2.6.25-rc1 must be 
> shipped in 4 stable kernels before they can be removed.
> 

Without comment on the validity of the exports themselves, I was more
interested in the principle of announcing these removals, and if it
was wanted.

Cheers,

Harvey

