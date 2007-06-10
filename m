Return-Path: <linux-kernel-owner+w=401wt.eu-S1763636AbXFJWiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763636AbXFJWiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 18:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759816AbXFJWiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 18:38:18 -0400
Received: from lucidpixels.com ([75.144.35.66]:37910 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759626AbXFJWiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 18:38:17 -0400
Date: Sun, 10 Jun 2007 18:38:16 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Mark Lord <liml@rtr.ca>
cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.22-rc regression: smartctl does not work with SATA disk
In-Reply-To: <466C7C35.7020105@rtr.ca>
Message-ID: <Pine.LNX.4.64.0706101837300.1302@p34.internal.lan>
References: <Pine.LNX.4.64.0706101049130.6348@kai.makisara.local>
 <466C7C35.7020105@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 10 Jun 2007, Mark Lord wrote:

> Kai Makisara wrote:
>> The command 'smartctl -a /dev/sdb' fails with 2.6.22-rc4 kernel. The disk 
>> /dev/sdb is a SATA disk. The command does work still with a real SCSI disk.
>
> Last time I checked, one must supply the "-d ata" parameter to smartctl
> for it to work with libata drives.  Has this changed?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Wow, apparently it has, I just tried it here:

p34:~# smartctl -a /dev/sda | head -n 5
smartctl version 5.37 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6 
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Raptor family
.. [snip] ..

p34:~# echo $?
0
p34:~#

Normally you always had to use the -d ata parameter.

Justin.
