Return-Path: <linux-kernel-owner+w=401wt.eu-S932429AbXBNSVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbXBNSVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 13:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932430AbXBNSVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 13:21:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38276 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429AbXBNSVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 13:21:02 -0500
Date: Wed, 14 Feb 2007 10:20:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vitaly Wool" <vitalywool@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: make probing for TXEN bug a config option
Message-Id: <20070214102056.aa024d70.akpm@linux-foundation.org>
In-Reply-To: <acd2a5930702140541n20752906ge1ff58efed460ed5@mail.gmail.com>
References: <20061226194317.3fd3ec14.vitalywool@gmail.com>
	<20070213224643.14d27cd3.akpm@linux-foundation.org>
	<acd2a5930702140037yff0b77dl2714ea7869bdde54@mail.gmail.com>
	<20070214004755.faa96e55.akpm@linux-foundation.org>
	<acd2a5930702140541n20752906ge1ff58efed460ed5@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 05:41:53 -0800
"Vitaly Wool" <vitalywool@gmail.com> wrote:

> On 2/14/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 14 Feb 2007 11:37:52 +0300 "Vitaly Wool" <vitalywool@gmail.com> wrote:
> > > Hmm, why? I can't think of a platform where one 8250-compatible UART is
> > > problematic and another isn't :)
> > >
> >
> > Is it not possible that the same kernel package can be installed on systems
> > which do and don't need this feature?  If so, we don't want to force the
> > provider of that package to create two packages.
> >
> > That, plus the chances of the package creator actually knowing about this
> > option aren't great.
> >
> > Generally, if it can be done at runtime it is better to do so, no?
> 
> Okay, yes, I see your point. The same kernel might actually be
> supporting several machines.
> 
> But having that as a config option doesn't look too attractive to me.
> What about adding a new flag to plat_serial 8250 stuff instead?

plat_serial8250_port.flags?  Dunno, I'm unfamiliar with it.  That seems to be how
the share_irqs option is handled.
