Return-Path: <linux-kernel-owner+w=401wt.eu-S968397AbXEHQ1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968397AbXEHQ1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968325AbXEHQ1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:27:00 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:44092 "EHLO
	vitb.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S968162AbXEHQ07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:26:59 -0400
Date: Tue, 8 May 2007 20:26:08 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: "Loeliger Jon-LOELIGER" <jdl@freescale.com>
Cc: "David Gibson" <david@gibson.dropbear.id.au>, <linuxppc-dev@ozlabs.org>,
       <linux-pcmcia@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] [POWERPC] dts: kill hardcoded phandles
Message-ID: <20070508202608.16c128a0@vitb.ru.mvista.com>
In-Reply-To: <AF0367BA48C55940A43CCF08DF35553C012AA472@az33exm24.fsl.freescale.net>
References: <20070508053049.18428.50622.stgit@localhost.localdomain>
	<20070508054855.18428.29080.stgit@localhost.localdomain>
	<20070508055431.GA21009@localhost.localdomain>
	<AF0367BA48C55940A43CCF08DF35553C012AA472@az33exm24.fsl.freescale.net>
X-Mailer: Claws Mail 2.9.1cvs30 (GTK+ 2.6.10; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 07:29:20 -0700
"Loeliger Jon-LOELIGER" <jdl@freescale.com> wrote:

> 
> > > -       interrupt-controller@f8200000 {
> > > -               linux,phandle = <f8200000>;
> > > +		pci_pic:interrupt-controller@f8200000 {
> > 
> > I'd like to establish a convention of putting a space after the : and
> > using capitals for labels unless there's a strong reason not to in a
> > particular case.  It makes them easier to visually distinguish next to
> > the node name.
> 
> Colon-space is easy and I'll buy it.
> I'm not big on uppercase shouting, though.
> 
> Perhaps something more like case or goto labels:?
> 
>     pci_pic:
>         interrupt-contoller@f8200000 {
> 
> if needed?
> 
I used middle solution 
	Pci_pic: interrupt-contoller@f8200000 {
so first letter of the label should be uppercase.
It makes them easily distinguishable and at the same time, not "shouting" manner.


-- 
Sincerely, 
Vitaly
