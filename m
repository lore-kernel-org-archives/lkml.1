Return-Path: <linux-kernel-owner+w=401wt.eu-S1030468AbXDPLgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030468AbXDPLgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030476AbXDPLgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:36:21 -0400
Received: from khc.piap.pl ([195.187.100.11]:43235 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030468AbXDPLgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:36:20 -0400
To: Mikko Tiihonen <mikko.tiihonen@iki.fi>
Cc: clemens@ladisch.de, bob.picco@hp.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] hpet: Enable hidden HPET on NVidia motherboards
References: <1176708094.22969.7.camel@dual.local>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 16 Apr 2007 13:36:19 +0200
In-Reply-To: <1176708094.22969.7.camel@dual.local> (Mikko Tiihonen's message of "Mon, 16 Apr 2007 10:21:33 +0300")
Message-ID: <m3y7kssg98.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikko Tiihonen <mikko.tiihonen@iki.fi> writes:

> Enables HPET for NVidia motherboards with broken BIOS. The patch reads
> the HPET address from the pci config space. The patch should also work
> if ACPI is disabled.
>
> The HPET search is done in early-quirks because even 
> DECLARE_PCI_FIXUP_EARLY was too late. If the new quirk causes problems
> it can be disabled with the nohpet boot option.
>
> The patch assumes that the BIOS has done the basic setup of HPET, but
> has not published the result in ACPI tables. This is at least true for
> some Asus and Gigabyte motherboards.

I think the code should only be enabled by its CONFIG_*.
-- 
Krzysztof Halasa
