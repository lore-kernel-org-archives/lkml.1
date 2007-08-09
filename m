Return-Path: <linux-kernel-owner+w=401wt.eu-S938719AbXHIFJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938719AbXHIFJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbXHIFJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:09:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60645 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754591AbXHIFJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:09:32 -0400
Date: Wed, 8 Aug 2007 22:09:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: early boot lockup with 2.6.23-rc1
Message-Id: <20070808220918.1e5de16f.akpm@linux-foundation.org>
In-Reply-To: <20070809045743.GA2342@nalle>
References: <20070808223120.GA2286@nalle>
	<20070808170211.4401c019.akpm@linux-foundation.org>
	<20070809045743.GA2342@nalle>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007 07:57:43 +0300 Mikko Rapeli <mikko.rapeli@iki.fi> wrote:

> On Wed, Aug 08, 2007 at 05:02:11PM -0700, Andrew Morton wrote:
> > On Thu, 9 Aug 2007 01:31:20 +0300
> > Mikko Rapeli <mikko.rapeli@iki.fi> wrote:
> > 
> > > Since 2.6.23-rc1 I can't boot an old k6 (with a funky IDE drive worth testing
> > > with libata). The boot hangs without a sound or letter prints on the
> > > screen right after grub, while 2.6.22.1 works fine.
> > 
> > Try adding the `earlyprintk=vga' parameter to the kernel command line?
> 
> Tried but didn't see anything.

So it died super-early.

> I'll try some git snapshots...

That would be good, thanks.

Often such an early crash is due to a config problem.  eg: chose the
wrong CPU type.  So I'd recommend that you triple-check that config,
especially under "Processor type and features" before diving into into the
bisection hunt.
