Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbZHDL3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbZHDL3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 07:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZHDL3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 07:29:48 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:35854 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbZHDL3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 07:29:47 -0400
Message-ID: <4A781C6E.7040900@pardus.org.tr>
Date: Tue, 04 Aug 2009 14:33:02 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.22 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [Bug #13471] Loading parport_pc kills the keyboard if ACPI is
 enabled
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>	<H5-1lZIIeYK.A.dWH.9XObKB@chimera>	<20090731151417.568094e5@lxorguk.ukuu.org.uk>	<4A7308E8.1000200@pardus.org.tr> <20090731161735.6a94ad9c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090731161735.6a94ad9c@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote On 31-07-2009 18:17:
> There have been few changes to parport_pc but one thing recent changed
> the probe for SuperIO chips via low addresses and that could be
> interfering.
>
> commit e2434dc1c19412639dd047a4d4eff8ed0e5d0d50
> Author: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
> Date:   Mon Jun 22 16:51:49 2009 +0100
>
> changed the behaviour slightly (hence asking about which release if it
> was a recent breakage). Its also a code area with very few changes so if
> you can find which one worked last, you should be able to transplant that
> parport_pc into 2.6.current and see if its parport or acpi triggered
> breakage.
>   

I've tested on 2.6.30.4 which has apparently this commit, no changes.

I've booted into Ubuntu 8.10 which has 2.6.28. The keyboard was working
correctly eventhough parport_pc was loaded. I removed and re-probed and
the keyboard is gone.

I've set BIOS settings to default, nope.

I'll try bisecting when I find the last-good/first-bad kernel version.
