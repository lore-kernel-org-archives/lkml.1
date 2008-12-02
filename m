Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbYLBJta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbYLBJta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 04:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYLBJtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 04:49:20 -0500
Received: from lucidpixels.com ([75.144.35.66]:44977 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYLBJtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 04:49:19 -0500
Date: Tue, 2 Dec 2008 04:49:18 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Soeren Sonnenburg <kernel@nn7.de>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux-ide <linux-ide@vger.kernel.org>
Subject: Re: ST31500341AS vs ICH10, exception Emask 0x50 SAct 0x1 SErr 0x280900
 action 0x6 frozen
In-Reply-To: <1228205289.29251.32.camel@localhost>
Message-ID: <alpine.DEB.1.10.0812020448270.10115@p34.internal.lan>
References: <1228205289.29251.32.camel@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Soeren Sonnenburg wrote:

> Dear all,
>
> I just purchased a seagate 1.5TB drive ST31500341AS, with firmware
> revision CC1G (which according to seagate is not affected by the cache
> flush bug) and I am getting the errors below (after almost a day of
> uptime without problems). The drive is replacing a 750G variant from
> seagate with which I had months of uptime and no errors whatsoever.
>
> I hope anyone has an idea?
>
> - relevant part of hdparm -I and lspci
>
> ATA device, with non-removable media
> 	Model Number:       ST31500341AS
> 	Firmware Revision:  CC1G
> 	Transport:          Serial
>
> 00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA
> AHCI Controller
>
> - the error(tm)

A few items:

          res 40/00:00:48:19:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
          ata3: SError: { UnrecovData HostInt 10B8B BadCRC }

These are usually realted to a bad cable or connector.

ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)

Did you remove the 1.5 Gbps jumper so it can run at 3.0 Gbps?

Justin.


