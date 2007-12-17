Return-Path: <linux-kernel-owner+w=401wt.eu-S933143AbXLQJNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbXLQJNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 04:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbXLQJNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 04:13:10 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:23623 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbXLQJNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 04:13:09 -0500
Message-ID: <47663DA1.6000204@msgid.tls.msk.ru>
Date: Mon, 17 Dec 2007 12:13:05 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: /sys/block [was: [PATCH 007 of 7] md: Get name for block	device
 in sysfs]
References: <20071214171950.1308.patches@notabene>	 <1071214062647.1928@suse.de>	 <3ae72650712150858v14681823td2b0410eb67b1d04@mail.gmail.com>	 <18277.43533.991986.323212@notabene.brown>	 <1197857414.2585.16.camel@lov.site>  <47660927.9070002@msgid.tls.msk.ru> <1197879879.2585.28.camel@lov.site> <47663431.8000603@msgid.tls.msk.ru>
In-Reply-To: <47663431.8000603@msgid.tls.msk.ru>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Kay Sievers wrote:
>> On Mon, 2007-12-17 at 08:29 +0300, Michael Tokarev wrote:
> []
>>> How to distinguish char devices from block devices in sysfs?
>>> Is the only way to read a symlink `subsystem' in the device
>>> directory?
>> By its subsystem value (block), from the symlink, from the environment,
>> or from $1.
> 
> Environment and $1 comes as arguments for hotplug helper, not
> when scanning /sys/.

By the way, that's one of reasons I asked about useful content
in uevent files (but failed to provide a patch so far ;).
In 2.6.23, those files ARE readable finally, but doesn't
contain much info yet.

/mjt
