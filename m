Return-Path: <linux-kernel-owner+w=401wt.eu-S1751419AbXA2NiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbXA2NiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 08:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbXA2NiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 08:38:24 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:43521 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbXA2NiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 08:38:24 -0500
Date: Mon, 29 Jan 2007 14:38:22 +0100 (MET)
From: Oliver Neukum <oliver@neukum.name>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: blacklist kernel boot option
User-Agent: KMail/1.9.1
Cc: Gerd Hoffmann <kraxel@suse.de>, linux-kernel@vger.kernel.org
References: <200701270222.36060.mista.tapas@gmx.net>
 <200701291344.45299.oliver@neukum.name>
 <Pine.LNX.4.61.0701291412300.5077@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0701291412300.5077@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701291438.25400.oliver@neukum.name>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 29. Januar 2007 14:23 schrieb Jan Engelhardt:
> 
> On Jan 29 2007 13:44, Oliver Neukum wrote:

> >What use is it to modularly compile something that almost everybody needs?
> 
> [correction: meant CONFIG_BLK_DEV_MD, because CONFIG_MD itself does
> not generate any code]
> 
> So just because almost everyone needs CONFIG_SCSI (SATA, usb_storage,
> you name it), you're going to compile that in as well? It's just
> another 180 KB [BLK_DEV_MD: ~100K] so let's compile it in!

For every module you waste PAGE_SIZE/2. In my system
oliver@valisk:~/Desktop/linux-2.6.20-6-greg> lsmod|wc
     46     158    1827
that's 92K. There is a point where the number of people who don't
need it grows too small to justify that.

> There is a reason initramfs exists, and it's not only for firmware
> loading or running custom scripts.

But shrinking the statically compiled kernel isn't one of them. You need
to look at the actual memory footprint.

	Regards
		Oliver
