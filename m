Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbXKXHP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbXKXHP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 02:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbXKXHPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 02:15:21 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:53294 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbXKXHPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 02:15:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R0c/f4Uo0yAXj/YpCUdPuKo6jeMYk6muYxhWA3NvvRN6+xHB4pQJN25FsbsG551H4We7PoHwlsbfSxMKapx93Fxrvj6claXX54g/EuXWQO9o+cuwWmYHqHoK5nrPvADUsAv0ME/cUTED9tPZ5I3ZY3aN5v8ObNBINbL9TVuyh7E=
Message-ID: <386072610711232315u13c8b685jbf6c44c6688ba5f@mail.gmail.com>
Date: Sat, 24 Nov 2007 15:15:18 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH 1/1] [MTD/NAND]: Add Blackfin BF52x on-chip NAND Flash controller driver support in bf5xx_nand driver
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Bryan Wu" <bryan.wu@analog.com>,
       "Michael Hennerich" <michael.hennerich@analog.com>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <1195886608.25590.59.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1195812893-26312-1-git-send-email-bryan.wu@analog.com>
	 <386072610711230625k23b68e49q6090b7eb27c2c039@mail.gmail.com>
	 <20071123135212.7c483aae@laptopd505.fenrus.org>
	 <200711231704.59948.rgetz@blackfin.uclinux.org>
	 <1195886608.25590.59.camel@pmac.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 24, 2007 2:43 PM, David Woodhouse <dwmw2@infradead.org> wrote:
>
> On Fri, 2007-11-23 at 17:04 -0500, Robin Getz wrote:
> > It could be a runtime if() but we don't currently have the is_mach() all set
> > up properly today.
> >
> > This is because on most systems that Blackfin ships on - memory is the
> > dominate cost of the system, and end users don't want to take the either the
> > storage (flash) hit of having code they don't use, or the run time (DRAM)
> > overhead. They are fine with compiling 2 kernels for two platforms if it
> > means things are cheaper. :)
> >
> > That being said, we still need to go back, and add things properly - and just
> > let gcc optimise things away if it is not used - c code is more maintainable
> > than all the ifdefs we have today.
> >
> > This is the goal - it will just take a little bit to get there.
>
> For now I suspect you could at least define machine_is_bf52x() and
> machine_is_bf54x() which are hard-coded to either zero or one according
> to the configuration, and at least you wouldn't need to add ifdefs to
> drivers.
>

We got some plan to do this, but maybe cpu_is_bf52x() and
cpu_is_bf54x() are better.
Thanks.

-Bryan
