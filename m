Return-Path: <linux-kernel-owner+w=401wt.eu-S1764912AbYEAVKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764912AbYEAVKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759593AbYEAVKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:10:25 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:12583 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686AbYEAVKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uvvVz5HXopQOM2xYkdKQBkk5NmM46jLPmoz/a0NfOfIPxC4cSK0myy4B4wvK76AEynJFXZ3W4eJqJgGU2okss6+N2lcBA0Vu0gnAgGynDZOSo2+Eu12H1zdZoCZwei1bvIzF67byJ6h8v4knCRcrAW7aF2YBlwEcTfDIbKZUp3A=
Message-ID: <86802c440805011410q17c24653l292ccb6dad211a06@mail.gmail.com>
Date: Thu, 1 May 2008 14:10:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Why such a big difference in init-time PCI resource call-paths (x86 vs x86_64) ?
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, TJ <linux@tjworld.net>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080501201111.GO20451@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209571638.25051.54.camel@hephaestion.lan.tjworld.net>
	 <200805011116.31782.jbarnes@virtuousgeek.org>
	 <20080501201111.GO20451@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 1:11 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Thu, May 01, 2008 at 11:16:31AM -0700, Jesse Barnes wrote:
>  > On Wednesday, April 30, 2008 9:07 am TJ wrote:
>  > > In preparation for writing a Windows-style PCI resource allocation
>  > > strategy
>  > >
>  > >  - use all e820 gaps for IOMEM resources; top-down allocation -
>  > >
>  > > and thus giving devices with large IOMEM requirements more chance of
>  > > allocation in the 32-bit address space below 4GB (see bugzilla #10461),
>
>  I tried that some time ago and it turned out that some systems have
>  mappings in holes and don't boot anymore when you fill the holes too much.
>  But that was only considering e820. if you do this it might work if you
>  do it really like windows and consider all resources, including ACPI.

wonder if using holes in MTRR AND e820 could help...

YH
