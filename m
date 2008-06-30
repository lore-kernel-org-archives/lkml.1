Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYF3ACr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYF3ACr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 20:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbYF3ACc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 20:02:32 -0400
Received: from hu-out-0506.google.com ([72.14.214.224]:12090 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbYF3AC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 20:02:29 -0400
Message-ID: <1d3f23370806291702g4344a2f9lb62f85cbb475fca4@mail.gmail.com>
Date: Mon, 30 Jun 2008 10:02:21 +1000
From: "John Williams" <john.williams@petalogix.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 12/60] microblaze_v4: Generic dts file for platforms
Cc: monstr@seznam.cz, linux-kernel@vger.kernel.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, "Michal Simek" <monstr@monstr.eu>
In-Reply-To: <fa686aa40806272249l7eae0c34k43a20ad41672b77a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
	 <fa686aa40806272249l7eae0c34k43a20ad41672b77a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2008 at 3:49 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, Jun 26, 2008 at 5:29 AM,  <monstr@seznam.cz> wrote:
>> From: Michal Simek <monstr@monstr.eu>

>>  arch/microblaze/platform/generic/system.dts |  300 +++++++++++++++++++++++++++

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
