Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZGAE5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZGAE5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 00:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbZGAE5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 00:57:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:38206 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbZGAE5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 00:57:14 -0400
Date: Tue, 30 Jun 2009 21:58:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] RO/NX protection for loadable kernel modules
Message-ID: <20090630215813.52ee354c@infradead.org>
In-Reply-To: <817ecb6f0906300744i4f11d7faldd10ef3834582812@mail.gmail.com>
References: <817ecb6f0906290816t2537e5des3b78b32c6fd16700@mail.gmail.com>
	<20090629083051.232bac68@infradead.org>
	<817ecb6f0906300611s3b21b85by54e689e073bd2012@mail.gmail.com>
	<20090630062939.4878fcbe@infradead.org>
	<817ecb6f0906300744i4f11d7faldd10ef3834582812@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 10:44:46 -0400
Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> >>
> >> Given that it will not reduce the number of #ifdefs, do you still
> >> think that NX should be made unconditional?
> >
> > I think that not only NX should be made unconditional, I also think
> > that the RO code should be unconditional.
> 
> So, the only conditional part would be the page-alignment of each of
> the three parts of a module. Is that correct understanding?

yep
(and for me, even that is debatable, but I can see the point for having
that conditional)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
