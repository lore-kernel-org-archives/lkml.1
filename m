Return-Path: <linux-kernel-owner+w=401wt.eu-S1752963AbYBXGQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbYBXGQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 01:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbYBXGPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 01:15:55 -0500
Received: from nn7.de ([85.214.94.156]:42961 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYBXGPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 01:15:55 -0500
Subject: Re: 2.6.25-current-git hangs on boot
From: Soeren Sonnenburg <kernel@nn7.de>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <6101e8c40802231100t3af57018r139de0b52cd556b5@mail.gmail.com>
References: <1203789325.4063.9.camel@localhost>
	 <6101e8c40802231100t3af57018r139de0b52cd556b5@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 24 Feb 2008 07:15:10 +0100
Message-Id: <1203833710.4006.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-23 at 20:00 +0100, Oliver Pinter wrote:
> the pci=nommconf kernel parameter helped it?

yes indeed, this switch reliably helps to over come the hang at *this
stage* (I tried booting with booth the switch and w/o).

however with 50% chance I still see a hang directly after

cpuidle: using governor ladder

note that I've never seen these hangs on 2.6.24* ...

Soeren

> On 2/23/08, Soeren Sonnenburg <kernel@nn7.de> wrote:
> > Hi,
> >
> > trying out newest git, I see a hang with
> > ACPI: SSDT 7feb9c10, 02ae (r1 APPLE CPU0Ist 3000 intl 20050309)
> > ACPI: SSDT 7feb9910, 02c3 (r1 APPLE CPU0Cst 3001 intl 20050309)
> > ...
> > ACPI: Processor [CPU0] (supports 8 throttling states)
> > ACPI: SSDT 7feb9f10, 0087 (r1 APPLE CPU1Ist 3000 intl 20050309)
> > ACPI: SSDT 7feb8f10, 0085 (r1 APPLE CPU1Cst 3001 intl 20050309)
> > ...
> > ACPI: ACPI0007:01 is registered as cooling_device1
> > ACPI: Processor [CPU1] (supports 8 throttling states)
> >
> > as the last message...
> >
> > Any ideas?
> > Soeren
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
