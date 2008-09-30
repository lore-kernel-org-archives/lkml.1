Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYI3Tux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYI3Tux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYI3Tun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:50:43 -0400
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:3508 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505AbYI3Tun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:50:43 -0400
From: Frans Pop <elendil@planet.nl>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: CD tray closes spontaneously after opening it
Date: Tue, 30 Sep 2008 21:50:37 +0200
User-Agent: KMail/1.9.9
Cc: "Tony Vroon" <tony@vroon.org>, linux-kernel@vger.kernel.org,
       "Tejun Heo" <tj@kernel.org>, "Jens Axboe" <jens.axboe@oracle.com>
References: <200809301247.05367.elendil@planet.nl> <200809301447.35915.elendil@planet.nl> <ac3eb2510809300655u319f8a9v58e4825f97ee329c@mail.gmail.com>
In-Reply-To: <ac3eb2510809300655u319f8a9v58e4825f97ee329c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809302150.38872.elendil@planet.nl>
X-OriginalArrivalTime: 30 Sep 2008 19:50:39.0708 (UTC) FILETIME=[D09ED9C0:01C92335]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2008, Kay Sievers wrote:
> Does:
>   /sbin/udevadm monitor --env
> print something while you see the tray closing?

I was somewhat lucky to reproduce it with that running and there was no 
output during the open or close. I guess that rules out udev?

I still don't know how to reliably reproduce this. It seems that after it 
has occurred once, it will not occur again unless the system is rebooted. 
But I'm not 100% sure of that.

Most times I've seen it was after playing a DVD when ejecting the disc to 
put it back in its box, but not when the DVD was inserted earlier.
But I've also seen it shortly after the system is booted when just opening 
the tray with no media inserted.

Just to be clear: until recently the drive has always behaved perfectly in 
the same situations.

> Does this also happen when you set:
>   /proc/sys/dev/cdrom/autoclose
> to 0?

I'll set that on boot using /etc/sysctl.conf and will report if I can 
still reproduce with that setting. I've checked that the "normal" value 
is 1.

Thanks.
