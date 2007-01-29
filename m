Return-Path: <linux-kernel-owner+w=401wt.eu-S1751384AbXA2NYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbXA2NYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 08:24:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXA2NYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 08:24:03 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:59043 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbXA2NYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 08:24:01 -0500
Date: Mon, 29 Jan 2007 14:23:13 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Oliver Neukum <oliver@neukum.name>
cc: Gerd Hoffmann <kraxel@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: blacklist kernel boot option
In-Reply-To: <200701291344.45299.oliver@neukum.name>
Message-ID: <Pine.LNX.4.61.0701291412300.5077@yvahk01.tjqt.qr>
References: <200701270222.36060.mista.tapas@gmx.net> <45BDD9C2.1020309@suse.de>
 <Pine.LNX.4.61.0701291331060.32356@yvahk01.tjqt.qr> <200701291344.45299.oliver@neukum.name>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 29 2007 13:44, Oliver Neukum wrote:
>Am Montag, 29. Januar 2007 13:40 schrieb Jan Engelhardt:
>> >Is that an real-live issue, with distro kernels being shipped with
>> >almost everything compiled as module these days?
>> 
>> For me it was. FC6 has at least CONFIG_MD=y, and SUSE also has
>> some =y that could be =m with the help of module autoload rules,
>> and some =y that could truly be =m. Those being =y cannot be
>> blacklisted.
>
>What use is it to modularly compile something that almost everybody needs?

[correction: meant CONFIG_BLK_DEV_MD, because CONFIG_MD itself does
not generate any code]

So just because almost everyone needs CONFIG_SCSI (SATA, usb_storage,
you name it), you're going to compile that in as well? It's just
another 180 KB [BLK_DEV_MD: ~100K] so let's compile it in!

There is a reason initramfs exists, and it's not only for firmware
loading or running custom scripts.
