Return-Path: <linux-kernel-owner+w=401wt.eu-S1759929AbXEaEgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929AbXEaEgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXEaEgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:36:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:3670 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXEaEgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:36:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rqv07KTDhfgQtD/Vm54uHAZMCh2pWWGRhU58jEEeNdFuh2SKqwwgDhIpVObDNXLbmM70kFdAt1276ZgbbZyyIh6PtS2cXEoMzl5oApEPzV4n1eUok4jQe3+t7NiRlXycSfAsRaWQvTBxMz+mV9VVqQ6xShqay2EMlccvmYt1Pyg=
Message-ID: <86802c440705302136h1f2da2d8j881e062dfa6b7d7a@mail.gmail.com>
Date: Wed, 30 May 2007 21:36:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] serial: convert early_uart to earlycon for 8250
Cc: "Andi Kleen" <ak@suse.de>, "Russell King" <rmk@arm.linux.org.uk>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440705302134l637df0fbm9a3b99eff19201@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705291844.00308.yinghai.lu@sun.com>
	 <20070530201335.94f73eb9.akpm@linux-foundation.org>
	 <86802c440705302134l637df0fbm9a3b99eff19201@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On 5/30/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 29 May 2007 18:43:59 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> >
> > > [PATCH 4/5] serial: convert early_uart to earlycon for 8250
> >
> > drivers/serial/8250_early.c: In function 'parse_options':
> > drivers/serial/8250_early.c:143: error: 'FIX_EARLYCON_MEM_BASE' undeclared (first use in this function)
> > drivers/serial/8250_early.c:143: error: (Each undeclared identifier is reported only once
> >
> > That was with http://userweb.kernel.org/~akpm/config-sony.txt, but this is
> > going to break a whole pile of architectures (alpha, powerpc, others).
>
> alpha, powerpc, others may need sth like ia64, if they do not support fixmap.
>
>

or create dummy fixmap.h that doesn't support fixmap.

YH
