Return-Path: <linux-kernel-owner+w=401wt.eu-S968193AbXEHO30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968193AbXEHO30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967955AbXEHO30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:29:26 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:44402 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968187AbXEHO3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:29:25 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/3] [POWERPC] dts: kill hardcoded phandles
Date: Tue, 8 May 2007 07:29:20 -0700
Message-ID: <AF0367BA48C55940A43CCF08DF35553C012AA472@az33exm24.fsl.freescale.net>
In-Reply-To: <20070508055431.GA21009@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/3] [POWERPC] dts: kill hardcoded phandles
Thread-Index: AceRNW55aiyvP772Smq5Yu2vzQu5YQAR2KLw
References: <20070508053049.18428.50622.stgit@localhost.localdomain><20070508054855.18428.29080.stgit@localhost.localdomain> <20070508055431.GA21009@localhost.localdomain>
From: "Loeliger Jon-LOELIGER" <jdl@freescale.com>
To: "David Gibson" <david@gibson.dropbear.id.au>,
       "Vitaly Bordug" <vitb@kernel.crashing.org>
Cc: <linuxppc-dev@ozlabs.org>, <linux-pcmcia@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > -       interrupt-controller@f8200000 {
> > -               linux,phandle = <f8200000>;
> > +		pci_pic:interrupt-controller@f8200000 {
> 
> I'd like to establish a convention of putting a space after the : and
> using capitals for labels unless there's a strong reason not to in a
> particular case.  It makes them easier to visually distinguish next to
> the node name.

Colon-space is easy and I'll buy it.
I'm not big on uppercase shouting, though.

Perhaps something more like case or goto labels:?

    pci_pic:
        interrupt-contoller@f8200000 {

if needed?

jdl
