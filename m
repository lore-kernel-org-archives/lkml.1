Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbYBLUJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbYBLUJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbYBLUJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:09:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39005 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbYBLUJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:09:27 -0500
Date: Tue, 12 Feb 2008 12:08:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: thomas.petazzoni@free-electrons.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, Linux-tiny@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Configure out DMI scanning code v2 (Linux Tiny)
Message-Id: <20080212120817.5d27d09d.akpm@linux-foundation.org>
In-Reply-To: <1202842605.12383.100.camel@cinder.waste.org>
References: <20080212100418.5de764da@crazy>
	<1202842605.12383.100.camel@cinder.waste.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 12:56:45 -0600
Matt Mackall <mpm@selenic.com> wrote:

> 
> On Tue, 2008-02-12 at 10:04 +0100, Thomas Petazzoni wrote:
> 
> > Turn CONFIG_DMI into a selectable option if EMBEDDED is defined, in
> > order to be able to remove the DMI table scanning code if it's not
> > needed, and then reduce the kernel code size.
> > 
> > With CONFIG_DMI (i.e before) :
> > 
> >    text    data     bss     dec     hex filename
> > 1076076  128656   98304 1303036  13e1fc vmlinux
> > 
> > Without CONFIG_DMI (i.e after) :
> > 
> >    text    data     bss     dec     hex filename
> > 1068092  126308   98304 1292704  13b9a0 vmlinux
> > 
> > Result:
> > 
> >    text    data     bss     dec     hex filename
> >   -7984   -2348       0  -10332   -285c vmlinux
> > 
> > The new option appears in "Processor type and features", only when
> > CONFIG_EMBEDDED is defined.

Given this:

> > This patch is part of the Linux Tiny project, and is based on previous
> > work done by Matt Mackall <mpm@selenic.com>.


> Acked-by: Matt Mackall <mpm@selenic.com>

That should have been "Signed-off-by:".  I'll speculatively make that
change.
