Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbYF3Gxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbYF3Gxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbYF3Gxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:53:40 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:38374 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbYF3Gxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:53:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=In-Reply-To:Received:Date:Cc:To:From:Subject:Mime-Version:Message-Id:Content-Transfer-Encoding:Content-Type:X-Abuse:X-Seznam-User:X-QM-Mark;
	b=FKuzNtan9S2a6qWGb4JZws3PvxGeS/i5RSNYAhFPVDm90XZFrGoONRHPBYH0uEDqt
	MXkIJnt5/gQG7t9wUQrjzELw9NuyG94zMo27Vtos77SgUJ52/FX+aOGiia5wIwZrjjw
	jXghrnzAh1Cgh92LonZPYqlPB0W9zBLiLLsYr0A=
In-Reply-To: <1d3f23370806291702g4344a2f9lb62f85cbb475fca4@mail.gmail.com>
Date: Mon, 30 Jun 2008 08:48:14 +0200 (CEST)
Cc: =?us-ascii?Q?Grant=20Likely?= <grant.likely@secretlab.ca>,
       linux-arch@vger.kernel.org,
       =?us-ascii?Q?Michal=20Simek?= <monstr@monstr.eu>, vapier.adi@gmail.com,
       arnd@arndb.de, matthew@wil.cx, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, drepper@redhat.com,
       linuxppc-dev@ozlabs.org, will.newton@gmail.com, hpa@zytor.com,
       John.Linn@xilinx.com, alan@lxorguk.ukuu.org.uk
To: =?us-ascii?Q?John=20Williams?= <john.williams@petalogix.com>
From: =?us-ascii?Q?Michal=20Simek?= <Monstr@seznam.cz>
Subject: =?us-ascii?Q?Re=3A=20=5BPATCH=2012=2F60=5D=20microblaze=5Fv4=3A=20Generic=20dts=20file=20for=20platforms?=
Mime-Version: 1.0
Message-Id: <4121.6644-31137-1228643821-1214808494@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="us-ascii"
X-Abuse: abuse@seznam.cz
X-Seznam-User: Monstr@seznam.cz
X-QM-Mark: email-qm5<127857096>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John, Steve and others,

in generic platform will be generic DTS which I sent in first versions. 
This DTS will be for simple platform. There is not copyright.

FDT generator add copyright notice on the top of file. I added it when I start 
to program this BSP. Xilinx only add their copyright line which is fine. 
We can talk how big can be this copyright but I am convinced that will be 
part of commented code forever because there is placed important information
which EDK version this file generated and which version of FDT this file generate.
We can talk about showing license there but I think this is out of topic now because there
won't be any license in first microblaze pack.

Michal

> Since this is a generated file, and entirely bitstream specific, does
> it make sense to include it in the kernel tree?  If it does, then is
> it produced from one of the Xilinx reference designs?  Can you add
> documentation to the header that specifies exactly which design
> version this .dts is for?

I think there's value in having a generic DTS as an example or
template, even if it doesn't correspond to any specific machine.
Agreed a comment block explaining this is valuable.

I'd almost oppose any attempt to include a standard DTS for things
like ML401 boards etc - they are just misleading.  Unless we do MD5
hashes on MHS files, and use them as the filenames, any attempt to
define a standard platform will just fail and confuse people.  Better
to show them how to generate the DTS for their system.

>> +/*
>> + * (C) Copyright 2007-2008 Xilinx, Inc.
>> + * (C) Copyright 2007-2008 Michal Simek
>> + *
>> + * Michal SIMEK <monstr@monstr.eu>
>
> If this is a generated file, then is this copyright notice even appropriate?

I agree.  I think Michal is just copying Xilinx's habit of putting
copyright headers in generated files, and it's one that we should stop
now.

Regards,

John
_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@ozlabs.org
https://ozlabs.org/mailman/listinfo/linuxppc-dev


