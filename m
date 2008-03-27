Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYC0MMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYC0MMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbYC0MMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:12:35 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:51481 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755893AbYC0MMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:12:34 -0400
Date: Thu, 27 Mar 2008 13:11:25 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jan Dittmer <jdi@l4x.org>
Subject: Re: linux-next: Tree for March 27
Message-ID: <20080327131125.6ec6d5ae@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <20080327115459.GB1686@cs181133002.pp.htv.fi>
References: <20080327183357.7c637aed.sfr@canb.auug.org.au>
	<20080327104224.2b98b561@hskinnemo-gx620.norway.atmel.com>
	<20080327104745.GA1686@cs181133002.pp.htv.fi>
	<20080327123226.452f0a3f@hskinnemo-gx620.norway.atmel.com>
	<20080327115459.GB1686@cs181133002.pp.htv.fi>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2008 12:11:26.0266 (UTC) FILETIME=[AE3E01A0:01C89003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 13:54:59 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> On Thu, Mar 27, 2008 at 12:32:26PM +0100, Haavard Skinnemoen wrote:
> > On Thu, 27 Mar 2008 12:47:45 +0200
> > Adrian Bunk <bunk@kernel.org> wrote:
> >   
> > > According to Jan's page, there's still a build error with the defconfig:
> > >   http://l4x.org/k/?d=40450#err  
> > 
> > Hmm...that must be a pretty ancient toolchain.  
> 
> The oldest compiler the kernel currently supports is gcc 3.2, and 
> whenever it's reasonably possible (noone expects you to backport avr32 
> support to gcc 3.2) the aim is to support all compilers back to gcc 
> 3.2, or at least as far as possible.

We do have some gcc 3.x patches lying around somewhere, but I don't
think that's something we want to inflict on others ;-)

The first toolchain we ever released to the outside was based on gcc
4.0.2, so it is "ancient" in the sense that it has lots of
avr32-specific bugs that later toolchains don't have. I agree that we
should still try to support it as long as possible.

> BTW: What's the status of avr32 support in upstream binutils and gcc?

Still stuck in legal hell, I think.

Haavard
