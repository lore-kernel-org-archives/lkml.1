Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbYB2M0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbYB2M0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760347AbYB2MZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:25:44 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58534 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758471AbYB2MZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:25:42 -0500
Date: Fri, 29 Feb 2008 13:25:14 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: linux-next: semaphore update merge conflicts
Message-ID: <20080229132514.00d5087e@hskinnemoen.norway.atmel.com>
In-Reply-To: <20080229231704.112d8112.sfr@canb.auug.org.au>
References: <20080229153958.fc34e281.sfr@canb.auug.org.au>
	<20080229111731.13840877@hskinnemoen.norway.atmel.com>
	<20080229231704.112d8112.sfr@canb.auug.org.au>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 23:17:04 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On Fri, 29 Feb 2008 11:17:31 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> >
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > 	arch/avr32/kernel/semaphore.c
> > > 		the avr32 tree appeared to just change spaces to tabs
> > > 		in this file so I removed it (as your changes did).
> > 
> > I yanked that change out of my tree. No point cleaning up that file if
> > it's going away.
> 
> OK, thanks.
> 
> By the way, is there some place I can get a cross compiler to build avr32
> kernels (or better yet a recipe for crosstool to make one)?

You can get the official toolchain from this page:

http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4118

I'm not sure about crosstool, but you can get a patched version of
buildroot from this page:

http://www.atmel.no/buildroot/

Maybe you can just grab the patches from buildroot and use them with
crosstool? Or I can send them to you if you don't want to download the
whole thing.

Haavard
