Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbZAWI7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbZAWI7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 03:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZAWI73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 03:59:29 -0500
Received: from cpsmtpo-eml04.KPNXCHANGE.COM ([213.75.38.153]:42955 "EHLO
	cpsmtpo-eml04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405AbZAWI72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 03:59:28 -0500
From: Frans Pop <elendil@planet.nl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: HP accelerometer driver: testers wanted
Date: Fri, 23 Jan 2009 09:59:25 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20090122213139.GD2159@elf.ucw.cz> <20090122221708.GA3430@elf.ucw.cz> <200901230011.31871.elendil@planet.nl>
In-Reply-To: <200901230011.31871.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901230959.25491.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jan 2009 08:59:26.0291 (UTC) FILETIME=[E48DD230:01C97D38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 January 2009, Frans Pop wrote:
> The LED lights up yellow, but I have problems telling if the disk gets
> parked or not. One time I got a green led and seemingly a fair amount
> of activity immediately after getting the yellow led.
>
> After looking at hpfall.c, I checked /sys/block/sda/device/unload_heads
> after a drop:
> $ cat /sys/block/sda/device/unload_heads
> 19616
> $ cat /sys/block/sda/device/unload_heads
> 0
>
> The last was at most 2 seconds after the first, certainly not 20...

I've just looked at hpcall.c a bit closer and I guess that's because of 
the alarm(2) call? I must admit having some problems reading that code.
