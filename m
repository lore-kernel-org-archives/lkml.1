Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbXJKMhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbXJKMhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbXJKMhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:37:39 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41321 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbXJKMhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:37:39 -0400
Date: Thu, 11 Oct 2007 14:37:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rick Niles <fniles@gnupooh.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: Help with rtc to hpet conversion of OSGPS driver
In-Reply-To: <470E109C.6020903@gnupooh.org>
Message-ID: <Pine.LNX.4.64.0710111437040.32234@fbirervta.pbzchgretzou.qr>
References: <470E109C.6020903@gnupooh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 11 2007 08:01, Rick Niles wrote:
>
> I've been trying to make the driver work with
> Fedora 7 and the 2.6.22 kernel, but the rtc_register() and other RTC functions
> seems to have been removed.

grep -r rtc_device_register drivers/rtc/

Does that help?

> I see they've been replaced by the corresponding
> HPET functions, which is great. However, hpet_register() always returns -16
> (EBUSY).  This could be because I lack the correct hardware (I'm running 32-bit
> Linux on a Athlon64 with an NVIDIA chipset) or some other reason.
