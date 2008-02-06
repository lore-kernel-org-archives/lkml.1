Return-Path: <linux-kernel-owner+w=401wt.eu-S1763415AbYBFCXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763415AbYBFCXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 21:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759196AbYBFCXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 21:23:48 -0500
Received: from gozer.dminteractive.com ([66.18.16.178]:39971 "EHLO
	gozer.dminteractive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758994AbYBFCXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 21:23:47 -0500
Date: Tue, 5 Feb 2008 20:23:46 -0600
From: Mike Hokenson <kernel+marvell@gozer.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Problem burning DVDs with Marvell 88SE6121 on pata_marvell
Message-ID: <20080206022346.GA8267@gozer.dminteractive.com>
References: <20080202223004.GA24490@gozer.dminteractive.com> <20080205152131.065ca0b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20080205152131.065ca0b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday, February 05, 2008 at 03:21PM, Andrew Morton wrote:
>
>(added linux-ide)

thanks

>On Sat, 2 Feb 2008 16:30:04 -0600
>Mike Hokenson <kernel+marvell@gozer.org> wrote:
>
>> I recently put together a new system with a MSI P35 PLATINUM and although
>> reading from data CDs, DVDs, and watching DVD movies is working fine, DVD
>> burning isn't. MSI's manual says "1 IDE port by Marvell 88SE6111", but
>> lspci says it's a 88SE6121. I have two DVD burners, a SONY DRU-510A and
>> a DRU-820A. They were both working fine with TDK DVD+R media on my ASUS
>> K8V SE DELUXE (VIA IDE controller) prior to the upgrade.
>> 
>> Here's what I see with dvd+rw-tools version 7.0-9:
>> 
>> sh# dvd+rw-mediainfo /dev/dvd > /dev/null          # this is blank media
>> :-[ GET CURRENT PERFORMACE failed with SK=5h/ASC=24h/ACQ=00h]: Input/output error
>> :-[ READ TOC failed with SK=5h/ASC=24h/ACQ=00h]: Input/output error
>> 
>> sh# growisofs -dvd-compat -speed=2.4 -Z /dev/dvd -rJ -joliet-long -quiet "burn"
>> Executing 'genisoimage -rJ -joliet-long -quiet burn | builtin_dd of=/dev/dvd obs=32k seek=0'
>> /dev/dvd: "Current Write Speed" is 2.5x1352KBps.
>> :-[ WRITE@LBA=70h failed with SK=3h/ASC=0Ch/ACQ=00h]: Input/output error
>> :-( write failed: Input/output error
>> /dev/dvd: flushing cache
>> /dev/dvd: closing track
>> :-[ CLOSE TRACK failed with SK=5h/ASC=30h/ACQ=05h]: Wrong medium type
>> /dev/dvd: closing disc
>> :-[ CLOSE DISC failed with SK=5h/ASC=30h/ACQ=05h]: Wrong medium type
>> 
>> sh# dvd+rw-mediainfo /dev/dvd > /dev/null
>> :-[ READ TRACK INFORMATION failed with SK=3h/ASC=11h/ACQ=05h]: Input/output error
>
>(this is 2.6.24)
>
>If nothing happens with this report in the next few days, please create an
>entry at bugzilla.kernel.org so we can keep an eye on it, thanks.
>
>Trying older kernels might be interesting, find out if it's a regression or
>if it was always this way.

2.6.13.14 shows the same problems and 2.6.22 doesn't see the controller.

It looks like most of the changes happened betwen it's introduction in
2.6.20 (v0.1.1) and 2.6.22 (v0.1.4), with some minor updates for internal
changes after that...

Mike
