Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbYHDGDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbYHDGDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbYHDGDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:03:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:18650 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYHDGC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J9Zt2s45B4XDg5OZ+YecAk3N3vHI9WGlfoq8fDH+rLZdpMskGA6wqIR8zRFH7QJIMH
         LB6VULMaR69j7W/vVVsZmlHdJ6Pp24fLmNb98Ugv7Sz0j+MEo+x2Kk6+zgQIzzcQg2qO
         x94YT/ZsvovkUTvui6FhLAKcnctAvBOQNGNvI=
Subject: Re: [PATCH 14/20] parisc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>, LKML <linux-kernel@vger.kernel.org>,
       "ralf@linux-mips.org" <ralf@linux-mips.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
In-Reply-To: <20080801231807.GA26550@colo.lackof.org>
References: <1216339783.6029.125.camel@brick>
	 <20080801160647.GA22049@colo.lackof.org> <1217625817.5846.5.camel@brick>
	 <20080801231807.GA26550@colo.lackof.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 22:52:27 -0700
Message-Id: <1217656347.5846.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-01 at 17:18 -0600, Grant Grundler wrote:
> On Fri, Aug 01, 2008 at 02:23:37PM -0700, Harvey Harrison wrote:
> ...
> > > Should this only be defined if BITS_PER_LONG is <=32  ?
> > 
> > The new byteorder headers only uses this if no __arch_swab64 is defined.
> > 
> > Further down in the parisc version, an __arch_swab64 is defined in the
> > BITS_PER_LONG >=32 case, making this moot.
> 
> Ok.
> 
> ...
> > Other than the endianness, any other concerns?
> 
> Have you had a chance to test this?

le-only personally (X86-32).

> Or can you point me at another big endian arch that has similar 
> use of header files that has been successfully tested?

AVR32 got a maintainer ack, I'm assuming that was tested.  It's not
functionally any different than the existing code really, other
than allowing compile-time folding in the cpu_to_{endian} helpers.

Mips was also acked, but that can be little or big endian.

> 
> I can arrange for access to parisc HW if you have time/interest
> in testing this yourself.

Sure, drop me a note.

Harvey

