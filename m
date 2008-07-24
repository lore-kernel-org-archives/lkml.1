Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYGXUKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYGXUKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYGXUJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:09:52 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:10294 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752669AbYGXUJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:09:51 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=T23D4YVb3yIYC1stDXsA:9 a=MKTcJ0-pWt__mAhpj1cA:7 a=iu5F8vHTZZNCfamWSNEHl23Rz0sA:4 a=P3kf5HlC9JQA:10 a=ET-sLiBBsbUA:10
Message-ID: <4888E188.4050708@shaw.ca>
Date: Thu, 24 Jul 2008 14:09:44 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: filipe.brandenburger@idilia.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Recommendation on an eSATA card well supported by Linux with
 built-in drivers and that supports hot plug
References: <fa.jn2UBng193xTV9fhfIdhKpQQKRo@ifi.uio.no>
In-Reply-To: <fa.jn2UBng193xTV9fhfIdhKpQQKRo@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filipe Brandenburger wrote:
> I'm looking for a good eSATA card that is supported by Linux, preferrently using built-in drivers (no need to compile the modules from the vendor), or at least that the vendor's drivers are packaged with dkms or something similar that makes it easy on kernel upgrades.
> 
> It's essential that the card supports hot-plugging, because we want to use it to plug backup drives and have them rotated. We are testing an eSATA drive from LaCie (if you have other recommendations on other vendors for eSATA external drives which have >2TB drives, I would appreciate them as well).
> 
> I tested the Adaptec eSATA II RAID 1225SA, but just to get the module to compile right it was a huge PITA, and I still didn't get it to recognize our LaCie drive (still not sure why). Instead of spending more time making that crap work, I would rather buy a different card, but then I would try to get one that works well with Linux out-of-the-box.
> 
> I looked at feature support of drivers, and it seems to me that the "ahci" driver seems to be the most complete of them, also being a standard interface. It supports the ICH6 chip from Intel and several others, however googling for it I couldn't find any eSATA card that would have this chip or use this driver. Do you know any eSATA card that uses the "ahci" driver? Will it support hot-plugging well?

Most AHCI controllers are built into chipsets, but I know that JMicron 
has some chips which can be found on add-in cards which are AHCI.

> 
> Other than the "ahci" driver, it seems to me that the "sata_sil24" driver seems to be the next best thing, with support for hot-plugging, etc. The card I have apparently does use it, but its PCI device id is 0244 which is not recognized by the driver as it is (apparently if the driver is patched to include this id it works with the card.) Is there a way to "force" the driver to recognize this PCI id other than recompiling it? And, is this driver really that good and does it support hot-plugging? Could someone recommend another card that would be supported out-of-the-box by this driver?

It looks like device id 0244 was just added to the driver this month:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=464b3286b4aa459059c6fda85ba55185fd21d9fc

As far as I'm aware this driver works well, though I have no personal 
experience with it..

> 
> I don't need RAID support on the card, it really does not matter to me as I won't be using it.
> 
> Any advice and recommendations will be much appreciated.
> 
> Thank you very much!
> 
> Filipe
> 
> (Please CC me on your answer if at all possible.)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

